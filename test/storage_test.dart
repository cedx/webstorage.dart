import "dart:convert";
import "dart:html";
import "package:test/test.dart";
import "package:webstorage/webstorage.dart";

/// Tests the features of the [WebStorage] class.
void main() => group("WebStorage", () {
	setUp(window.sessionStorage.clear);

	group(".keys", () {
		test("should return an empty list for an empty storage", () {
			expect(SessionStorage().keys, isEmpty);
		});

		test("should return the list of keys for a non-empty storage", () {
			window.sessionStorage["foo"] = "bar";
			window.sessionStorage["bar"] = "baz";
			expect(SessionStorage().keys, orderedEquals(["foo", "bar"]));
		});
	});

	group(".length", () {
		test("should return zero for an empty storage", () {
			expect(SessionStorage(), isEmpty);
		});

		test("should return the number of entries for a non-empty storage", () {
			window.sessionStorage["foo"] = "bar";
			window.sessionStorage["bar"] = "baz";
			expect(SessionStorage(), hasLength(2));
		});
	});

	group(".onChange", () {
		test("should trigger an event when a value is added", () {
			SessionStorage()
				..onChange.listen(expectAsync1((event) {
					expect(event.key, "foo");
					expect(event.oldValue, isNull);
					expect(event.newValue, "bar");
				}))
				..set("foo", "bar");
		});

		test("should trigger an event when a value is updated", () {
			window.sessionStorage["foo"] = "bar";
			SessionStorage()
				..onChange.listen(expectAsync1((event) {
					expect(event.key, "foo");
					expect(event.oldValue, "bar");
					expect(event.newValue, "baz");
				}))
				..set("foo", "baz");
		});

		test("should trigger an event when a value is removed", () {
			window.sessionStorage["foo"] = "bar";
			SessionStorage()
				..onChange.listen(expectAsync1((event) {
					expect(event.key, "foo");
					expect(event.oldValue, "bar");
					expect(event.newValue, isNull);
				}))
				..remove("foo");
		});

		test("should trigger an event when the storage is cleared", () {
			window.sessionStorage["foo"] = "bar";
			window.sessionStorage["bar"] = "baz";

			SessionStorage()
				..onChange.listen(expectAsync1((event) {
					expect(event.key, isNull);
					expect(event.oldValue, isNull);
					expect(event.newValue, isNull);
				}))
				..clear();
		});
	});

	group(".clear()", () {
		test("should remove all storage entries", () {
			window.sessionStorage["foo"] = "bar";
			window.sessionStorage["bar"] = "baz";

			final service = SessionStorage();
			expect(service, hasLength(2));

			service.clear();
			expect(service, isEmpty);
		});
	});

	group(".containsKey()", () {
		test("should return `false` if the specified key is not contained", () {
			expect(SessionStorage().containsKey("foo"), isFalse);
		});

		test("should return `true` if the specified key is contained", () {
			final service = SessionStorage();
			window.sessionStorage["foo"] = "bar";
			expect(service.containsKey("foo"), isTrue);
			expect(service.containsKey("bar"), isFalse);
		});
	});

	group(".get()", () {
		test("should properly get the storage entries", () {
			final service = SessionStorage();
			expect(service["foo"], isNull);

			window.sessionStorage["foo"] = "bar";
			expect(service["foo"], "bar");

			window.sessionStorage["foo"] = "123";
			expect(service["foo"], "123");
		});

		test("should return the given default value if the key is not found", () {
			expect(SessionStorage().get("bar", "123"), "123");
		});
	});

	group(".getObject()", () {
		test("should properly get the deserialized storage entries", () {
			final service = SessionStorage();
			expect(service.getObject("foo"), isNull);

			window.sessionStorage["foo"] = "123";
			expect(service.getObject("foo"), 123);

			window.sessionStorage["foo"] = '"bar"';
			expect(service.getObject("foo"), "bar");

			window.sessionStorage["foo"] = '{"baz": "qux"}';
			expect(service.getObject("foo"), isA<Map>()
				.having((map) => map, "length", hasLength(1))
				.having((map) => map["baz"], "entry", "qux"));
		});

		test("should return the default value if the value can't be deserialized", () {
			window.sessionStorage["foo"] = "bar";
			expect(SessionStorage().getObject("foo", "defaultValue"), "defaultValue");
		});
	});

	group(".putObjectIfAbsent()", () {
		test("should add a new entry if it does not exist", () {
			final service = SessionStorage();
			expect(window.sessionStorage["foo"], isNull);
			expect(service.putObjectIfAbsent("foo", () => 123), 123);
			expect(window.sessionStorage["foo"], "123");
		});

		test("should not add a new entry if it already exists", () {
			final service = SessionStorage();
			window.sessionStorage["bar"] = "123";
			expect(service.putObjectIfAbsent("bar", () => 456), 123);
			expect(window.sessionStorage["bar"], "123");
		});
	});

	group(".remove()", () {
		test("should properly remove the storage entries", () {
			final service = SessionStorage();
			window.sessionStorage["foo"] = "bar";
			window.sessionStorage["bar"] = "baz";
			expect(window.sessionStorage["foo"], "bar");

			service.remove("foo");
			expect(window.sessionStorage["foo"], isNull);
			expect(window.sessionStorage["bar"], "baz");

			service.remove("bar");
			expect(window.sessionStorage["bar"], isNull);
		});
	});

	group(".set()", () {
		test("should properly set the storage entries", () {
			final service = SessionStorage();
			expect(window.sessionStorage["foo"], isNull);
			service["foo"] = "bar";
			expect(window.sessionStorage["foo"], "bar");
			service["foo"] = "123";
			expect(window.sessionStorage["foo"], "123");
		});
	});

	group(".setObject()", () {
		test("should properly serialize and set the storage entries", () {
			final service = SessionStorage();
			expect(window.sessionStorage["foo"], isNull);
			service.setObject("foo", 123);
			expect(window.sessionStorage["foo"], "123");
			service.setObject("foo", "bar");
			expect(window.sessionStorage["foo"], '"bar"');
			service.setObject("foo", {"key": "value"});
			expect(window.sessionStorage["foo"], '{"key":"value"}');
		});
	});

	group("to JSON", () {
		test("should return an empty map for an empty storage", () {
			expect(jsonEncode(SessionStorage()), "{}");
		});

		test("should return a non-empty map for a non-empty storage", () {
			final json = jsonEncode(SessionStorage()
				..set("foo", "bar")
				..set("baz", "qux"));

			expect(json, allOf(contains('"foo":"bar"'), contains('"baz":"qux"')));
		});
	});
});
