# Events
Every time one or several values are changed (added, removed or updated) through the `LocalStorage` or `SessionStorage` class,
a [StorageEvent](https://api.dart.dev/stable/dart-html/StorageEvent-class.html) of type `change` is emitted.

These events are exposed as [Stream](https://api.dart.dev/stable/dart-async/Stream-class.html), you can listen to them using the `onChange` property:

```dart
import "package:webstorage/webstorage.dart";

void main() {
	final service = LocalStorage();
	service.onChange.listen((event) =>
		print("${event.key}: ${event.oldValue} => ${event.newValue}")
	);

	service["foo"] = "bar"; // "foo: null => bar"
	service["foo"] = "baz"; // "foo: bar => baz"
	service.remove("foo"); // "foo: baz => null"
}
```

The values contained in the `newValue` and `oldValue` properties of the [StorageEvent](https://api.dart.dev/stable/dart-html/StorageEvent-class.html) instances are the raw storage values.
If you use the `WebStorage.setObject()` method to store a value, you will get the serialized string value, not the original value passed to the method:

```dart
storage.setObject("foo", {"bar": "baz"});
// "foo: null => {\"bar\": \"baz\"}"
```

## Changes in the context of another document
The `LocalStorage` and `SessionStorage` classes support the global [storage events](https://developer.mozilla.org/en-US/docs/Web/API/Window/storage_event).

When a change is made to the storage area within the context of another document (i.e. in another tab or `<iframe>`), a `change` event can be emitted to notify the modification.

The class constructors have an optional `listenToGlobalEvents` parameter that allows to enable the subscription to the global storage events:

```dart
import "package:webstorage/webstorage.dart";

void main() {
	// Enable the subscription to the global events of the local storage.
	final service = LocalStorage(listenToGlobalEvents: true);

	// Also occurs when the local storage is changed in another document.
	service.onChange.listen((event) => { /* ... */ });

	// Later, cancel the subscription to the global storage events.
	service.destroy();
}
```

!> When you enable the subscription to the global [storage events](https://developer.mozilla.org/en-US/docs/Web/API/Window/storage_event),
you must take care to call the [destroy()](usage/api.md) method when you have finished with the service in order to avoid a memory leak.
