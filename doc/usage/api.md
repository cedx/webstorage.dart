---
path: src/branch/master
source: lib/src/web_storage.dart
---

# Programming interface
This package provides two services dedicated to the Web Storage: the `LocalStorage` and `SessionStorage` classes.

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();

	service["foo"] = "bar";
	print(service["foo"]); // "bar"

	service.setObject("foo", {"baz": "qux"});
	print(service.getObject("foo")); // {"baz": "qux"}
}
```

Each class extends from the `WebStorage` abstract class that implements the [`Map`](https://api.dart.dev/stable/dart-core/Map-class.html) interface and has the following API:

## Iterable&lt;String&gt; get **keys**
Returns the keys of the associated storage:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();
	print(service.keys); // []

	service["foo"] = "bar";
	print(service.keys); // ["foo"]
}
```

## int get **length**
Returns the number of entries in the associated storage:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();
	print(service.length); // 0

	service["foo"] = "bar";
	print(service.length); // 1
}
```

## void **clear**()
Removes all entries from the associated storage:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();

	service["foo"] = "bar";
	print(service.length); // 1

	service.clear();
	print(service.length); // 0
}
```

## bool **containsKey**(String key)
Returns a boolean value indicating whether the associated storage contains the specified key:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();
	print(service.containsKey("foo")); // false

	service["foo"] = "bar";
	print(service.containsKey("foo")); // true
}
```

## void **destroy**()
When a service is instantiated, it can listen to the global [storage events](https://developer.mozilla.org/en-US/docs/Web/API/Window/storage_event).
When you have done using the service instance, you should call the `destroy()` method to cancel the subscription to these events.

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	// Work with the service...
	final service = LocalStorage(listenToGlobalEvents: true);

	// Later, cancel the subscription to the storage events.
	service.destroy();
}
```

See the [events](events.md) section for more information.

## String **get**(String key, [String defaultValue])
Returns the value associated to the specified key:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();
	print(service.get("foo")); // null
	print(service.get("foo", "qux")); // "qux"

	service["foo"] = "bar";
	print(service.get("foo")); // "bar"
}
```

Returns `null` or the given default value if the key is not found.

## dynamic **getObject**(String key, [dynamic defaultValue])
Deserializes and returns the value associated to the specified key:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();
	print(service.getObject("foo")); // null
	print(service.getObject("foo", "qux")); // "qux"

	service.setObject("foo", {"bar": "baz"});
	print(service.getObject("foo")); // {"bar": "baz"}
}
```

!!! info
	The value is deserialized using the [`jsonDecode`](https://api.dart.dev/stable/dart-convert/jsonDecode.html) function.

Returns `null` or the given default value if the key is not found.

## dynamic **putObjectIfAbsent**(String key, dynamic Function() ifAbsent)
Looks up the value of the specified key, or add a new value if it isn't there.

Returns the deserialized value associated to the key, if there is one.
Otherwise calls `ifAbsent` to get a new value, serializes it and associates the key to that value, and then returns the new value:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();
	print(service.containsKey("foo")); // false

	var value = service.putObjectIfAbsent("foo", () => 123);
	print(service.containsKey("foo")); // true
	print(value); // 123

	value = service.putObjectIfAbsent("foo", () => 456);
	print(value); // 123
}
```

!!! info
	The value is serialized using the [`jsonEncode`](https://api.dart.dev/stable/dart-convert/jsonEncode.html) function,
	and deserialized using the [`jsonDecode`](https://api.dart.dev/stable/dart-convert/jsonDecode.html) function.

## String **remove**(String key)
Removes the value associated to the specified key:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();

	service["foo"] = "bar";
	print(service.containsKey("foo")); // true

	print(service.remove("foo")); // "bar"
	print(service.containsKey("foo")); // false
}
```

Returns the value associated with the specified key before it was removed.

## void **set**(String key, String value)
Associates a given value to the specified key:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();
	print(service.get("foo")); // null

	service.set("foo", "bar");
	print(service.get("foo")); // "bar"
}
```

## void **setObject**(String key, dynamic value)
Serializes and associates a given value to the specified key:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();
	print(service.getObject("foo")); // null

	service.setObject("foo", {"bar": "baz"});
	print(service.getObject("foo")); // {"bar": "baz"}
}
```

!!! info
	The value is serialized using the [`jsonEncode`](https://api.dart.dev/stable/dart-convert/jsonEncode.html) function.
