---
path: src/branch/master
source: lib/src/simple_change.dart
---

# Events
Every time one or several values are changed (added, removed or updated) through the `LocalStorage` or `SessionStorage` class, a `changes` event is triggered.

These events are exposed as [`Stream`](https://api.dart.dev/stable/dart-async/Stream-class.html), you can listen to them using the `onChanges` property:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	LocalStorage().onChanges.listen((changes) {
		for (final entry in changes.entries) print("${entry.key}: ${entry.value}");
	});
}
```

The changes are expressed as a [`Map`](https://api.dart.dev/stable/dart-core/Map-class.html) of `SimpleChange` instances, where a `null` property indicates an absence of value:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	final storage = LocalStorage();
	storage.onChanges.listen((changes) {
		for (final entry in changes.entries) print({
			"key": entry.key,
			"current": entry.value.currentValue,
			"previous": entry.value.previousValue
		});
	});

	storage["foo"] = "bar";
	// Prints: {"key": "foo", "current": "bar", "previous": null}

	storage["foo"] = "baz";
	// Prints: {"key": "foo", "current": "baz", "previous": "bar"}

	storage.remove("foo");
	// Prints: {"key": "foo", "current": null, "previous": "baz"}
}
```

The values contained in the `currentValue` and `previousValue` properties of the `SimpleChange` instances are the raw storage values. If you use the `WebStorage.setObject()` method to store a value, you will get the serialized string value, not the original value passed to the method:

``` dart
storage.setObject("foo", <String, String>{"bar": "baz"});
// Prints: {"key": "foo", "current": "{\"bar\": \"baz\"}", "previous": null}
```

## Changes in the context of another document
The `WebStorage` parent class supports the global [storage events](https://developer.mozilla.org/en-US/docs/Web/API/Window/storage_event).

When a change is made to the storage area within the context of another document (i.e. in another tab or `<iframe>`), a `changes` event can be triggered to notify the modification.

The class constructors have a `listenToStorageEvents` parameter that allows to enable the subscription to the global storage events:

``` dart
import "package:webstorage/webstorage.dart";

void main() {
	// Enable the subscription to the global events of the local storage.
	final storage = LocalStorage(listenToStorageEvents: true);

	storage.onChanges.listen((changes) {
		// Also occurs when the local storage is changed in another document.
	});

	// Later, cancel the subscription to the storage events.
	storage.destroy();
}
```

!!! important
	When you enable the subscription to the global [storage events](https://developer.mozilla.org/en-US/docs/Web/API/Window/storage_event), you must take care to call the `destroy()` method when you have finished with the service in order to avoid a memory leak.
