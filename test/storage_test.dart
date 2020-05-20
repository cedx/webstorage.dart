import "dart:html" as dom;
import "package:test/test.dart";
import "package:webstorage/webstorage.dart";

/// Tests the features of the [WebStorage] class.
void main() => group("WebStorage", () {
	setUp(dom.window.sessionStorage.clear);

	group(".keys", () {
		test("should return an empty list for an empty storage", () {
			expect(SessionStorage().keys, isEmpty);
		});

		test("should return the list of keys for a non-empty storage", () {
			dom.window.sessionStorage["foo"] = "bar";
			dom.window.sessionStorage["bar"] = "baz";
			expect(SessionStorage().keys, orderedEquals(["foo", "bar"]));
		});
	});

	group(".length", () {
		test("should return zero for an empty storage", () {
			expect(SessionStorage(), isEmpty);
		});

		test("should return the number of entries for a non-empty storage", () {
			dom.window.sessionStorage["foo"] = "bar";
			dom.window.sessionStorage["bar"] = "baz";
			expect(SessionStorage(), hasLength(2));
		});
	});

	group(".onChanges", () {
		test("should trigger an event when a value is added", () {
			final storage = SessionStorage();
			storage.onChanges.listen(expectAsync1((changes) {
				expect(changes, hasLength(1));

				final record = changes.values.first;
				expect(changes.keys.first, "foo");
				expect(record.currentValue, "bar");
				expect(record.previousValue, isNull);
			}));

			storage["foo"] = "bar";
		});

		test("should trigger an event when a value is updated", () {
			dom.window.sessionStorage["foo"] = "bar";

			final storage = SessionStorage();
			storage.onChanges.listen(expectAsync1((changes) {
				expect(changes, hasLength(1));

				final record = changes.values.first;
				expect(changes.keys.first, "foo");
				expect(record.currentValue, "baz");
				expect(record.previousValue, "bar");
			}));

			storage["foo"] = "baz";
		});

		test("should trigger an event when a value is removed", () {
			dom.window.sessionStorage["foo"] = "bar";

			final storage = SessionStorage();
			storage.onChanges.listen(expectAsync1((changes) {
				expect(changes, hasLength(1));

				final record = changes.values.first;
				expect(changes.keys.first, "foo");
				expect(record.currentValue, isNull);
				expect(record.previousValue, "bar");
			}));

			storage.remove("foo");
		});

		test("should trigger an event when the storage is cleared", () {
			dom.window.sessionStorage["foo"] = "bar";
			dom.window.sessionStorage["bar"] = "baz";

			final storage = SessionStorage();
			storage.onChanges.listen(expectAsync1((changes) {
				expect(changes, hasLength(2));

				var record = changes.values.first;
				expect(changes.keys.first, "foo");
				expect(record.currentValue, isNull);
				expect(record.previousValue, "bar");

				record = changes.values.last;
				expect(changes.keys.last, "bar");
				expect(record.currentValue, isNull);
				expect(record.previousValue, "baz");
			}));

			storage.clear();
		});
	});

	group(".clear()", () {
		test("should remove all storage entries", () {
			dom.window.sessionStorage["foo"] = "bar";
			dom.window.sessionStorage["bar"] = "baz";

			final storage = SessionStorage();
			expect(storage, hasLength(2));

			storage.clear();
			expect(storage, isEmpty);
		});
	});

	group(".containsKey()", () {
		test("should return `false` if the specified key is not contained", () {
			expect(SessionStorage().containsKey("foo"), isFalse);
		});

		test("should return `true` if the specified key is contained", () {
			final storage = SessionStorage();
			dom.window.sessionStorage["foo"] = "bar";
			expect(storage.containsKey("foo"), isTrue);
			expect(storage.containsKey("bar"), isFalse);
		});
	});

	group(".get()", () {
		test("should properly get the storage entries", () {
			final storage = SessionStorage();
			expect(storage["foo"], isNull);

			dom.window.sessionStorage["foo"] = "bar";
			expect(storage["foo"], "bar");

			dom.window.sessionStorage["foo"] = "123";
			expect(storage["foo"], "123");
		});

		test("should return the given default value if the key is not found", () {
			expect(SessionStorage().get("bar", "123"), "123");
		});
	});

	group(".getObject()", () {
		test("should properly get the deserialized storage entries", () {
			final storage = SessionStorage();
			expect(storage.getObject("foo"), isNull);
			expect(storage.getObject("foo", {"key": "value"}), isA<Map>()
				.having((map) => map, "length", hasLength(1))
				.having((map) => map["key"], "entry", "value"));

			dom.window.sessionStorage["foo"] = "123";
			expect(storage.getObject("foo"), 123);

			dom.window.sessionStorage["foo"] = '"bar"';
			expect(storage.getObject("foo"), "bar");

			dom.window.sessionStorage["foo"] = '{"key": "value"}';
			expect(storage.getObject("foo"), isA<Map>()
				.having((map) => map, "length", hasLength(1))
				.having((map) => map["key"], "entry", "value"));
		});

		test("should return the default value if the value can\"t be deserialized", () {
			dom.window.sessionStorage["foo"] = "bar";
			expect(SessionStorage().getObject("foo", "defaultValue"), "defaultValue");
		});
	});

	group(".putObjectIfAbsent()", () {
		test("should add a new entry if it does not exist", () {
			final storage = SessionStorage();
			expect(dom.window.sessionStorage["foo"], isNull);
			expect(storage.putObjectIfAbsent("foo", () => 123), 123);
			expect(dom.window.sessionStorage["foo"], "123");
		});

		test("should not add a new entry if it already exists", () {
			final storage = SessionStorage();
			dom.window.sessionStorage["bar"] = "123";
			expect(storage.putObjectIfAbsent("bar", () => 456), 123);
			expect(dom.window.sessionStorage["bar"], "123");
		});
	});

	group(".remove()", () {
		test("should properly remove the storage entries", () {
			final storage = SessionStorage();
			dom.window.sessionStorage["foo"] = "bar";
			dom.window.sessionStorage["bar"] = "baz";
			expect(dom.window.sessionStorage["foo"], "bar");

			storage.remove("foo");
			expect(dom.window.sessionStorage["foo"], isNull);
			expect(dom.window.sessionStorage["bar"], "baz");

			storage.remove("bar");
			expect(dom.window.sessionStorage["bar"], isNull);
		});
	});

	group(".set()", () {
		test("should properly set the storage entries", () {
			final storage = SessionStorage();
			expect(dom.window.sessionStorage["foo"], isNull);
			storage["foo"] = "bar";
			expect(dom.window.sessionStorage["foo"], "bar");
			storage["foo"] = "123";
			expect(dom.window.sessionStorage["foo"], "123");
		});
	});

	group(".setObject()", () {
		test("should properly serialize and set the storage entries", () {
			final storage = SessionStorage();
			expect(dom.window.sessionStorage["foo"], isNull);
			storage.setObject("foo", 123);
			expect(dom.window.sessionStorage["foo"], "123");
			storage.setObject("foo", "bar");
			expect(dom.window.sessionStorage["foo"], '"bar"');
			storage.setObject("foo", {"key": "value"});
			expect(dom.window.sessionStorage["foo"], '{"key":"value"}');
		});
	});
});
