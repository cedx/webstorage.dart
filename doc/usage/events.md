path: blob/master
source: lib/src/simple_change.dart

# Events
Every time one or several values are changed (added, removed or updated) through the `LocalStorage` or `SessionStorage` class, a `changes` event is triggered.

These events are exposed as [`Stream`](https://api.dart.dev/stable/dart-async/Stream-class.html), you can listen to them using the `onChanges` property:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  LocalStorage().onChanges.listen((changes) {
    for (final entry in changes.entries) print('${entry.key}: ${entry.value}');
  });
}
```

The changes are expressed as a [`Map`](https://api.dart.dev/stable/dart-core/Map-class.html) of `SimpleChange` instances, where a `null` property indicates an absence of value:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();
  storage.onChanges.listen((changes) {
    for (final entry in changes.entries) print({
      'key': entry.key,
      'current': entry.value.currentValue,
      'previous': entry.value.previousValue
    });
  });

  storage['foo'] = 'bar';
  // Prints: {"key": "foo", "current": "bar", "previous": null}

  storage['foo'] = 'baz';
  // Prints: {"key": "foo", "current": "baz", "previous": "bar"}

  storage.remove('foo');
  // Prints: {"key": "foo", "current": null, "previous": "baz"}
}
```

The values contained in the `currentValue` and `previousValue` properties of the `SimpleChange` instances are the raw storage values. If you use the `WebStorage.setObject()` method to store a value, you will get the serialized string value, not the original value passed to the method:

```dart
storage.setObject('foo', <String, String>{'bar': 'baz'});
// Prints: {"key": "foo", "current": "{\"bar\": \"baz\"}", "previous": null}
```

!!! info
    [Storage events](https://developer.mozilla.org/en-US/docs/Web/API/Window/storage_event) are partially supported: except when the [`Storage.clear()`](https://developer.mozilla.org/en-US/docs/Web/API/Storage/clear) method is called, whenever the storage is changed in the context of another document, a `changes` event is triggered.
