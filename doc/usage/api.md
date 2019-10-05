path: blob/master
source: lib/src/storage.dart

# Programming interface
This package provides two services dedicated to the Web Storage: the `LocalStorage` and `SessionStorage` classes.

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();

  storage['foo'] = 'bar';
  print(storage['foo']); // "bar"

  storage.setObject('foo', <String, String>{'baz': 'qux'});
  print(storage.getObject('foo')); // {"baz": "qux"}
}
```

Each class extends from the `WebStorage` abstract class that implements the [`Map`](https://api.dart.dev/stable/dart-core/Map-class.html) interface and has the following API:

## Iterable&lt;String&gt; get **keys**
Returns the keys of the the associated storage:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();
  print(storage.keys); // []
    
  storage['foo'] = 'bar';
  print(storage.keys); // ["foo"]
}
```

## int get **length**
Returns the number of entries in the associated storage:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();
  print(storage.length); // 0
    
  storage['foo'] = 'bar';
  print(storage.length); // 1
}
```

## void **clear**()
Removes all entries from the associated storage:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();

  storage['foo'] = 'bar';
  print(storage.length); // 1
    
  storage.clear();
  print(storage.length); // 0
}
```

## bool **containsKey**(String key)
Returns a boolean value indicating whether the associated storage contains the specified key:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();
  print(storage.containsKey('foo')); // false
    
  storage['foo'] = 'bar';
  print(storage.containsKey('foo')); // true
}
```

## void **destroy**()
When a service is instantiated, it automatically listens for
the [storage events](https://developer.mozilla.org/en-US/docs/Web/API/Window/storage_event).
When you have done using the service instance, it's preferable to call the `destroy()` method to cancel the subscription to these events.

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  // Work with the service...
  final storage = LocalStorage();

  // Later, cancel the subscription to the storage events.
  storage.destroy();
}
```

## String **get**(String key, [String defaultValue])
Returns the value associated to the specified key:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();
  print(storage.get('foo')); // null
  print(storage.get('foo', 'qux')); // "qux"

  storage['foo'] = 'bar';
  print(storage.get('foo')); // "bar"
}
```

Returns `null` or the given default value if the key is not found.

## dynamic **getObject**(String key, [dynamic defaultValue])
Deserializes and returns the value associated to the specified key:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();
  print(storage.getObject('foo')); // null
  print(storage.getObject('foo', 'qux')); // "qux"
  
  storage.setObject('foo', {bar: 'baz'});
  print(storage.getObject('foo')); // {bar: "baz"}
}
```

!!! info
    The value is deserialized using the [`jsonDecode`](https://api.dart.dev/stable/dart-convert/jsonDecode.html) function.

Returns a `null` reference or the given default value if the key is not found.

## String **remove**(String key)
Removes the value associated to the specified key:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();

  storage['foo'] = 'bar';
  print(storage.containsKey('foo')); // true
    
  print(storage.remove('foo')); // "bar"
  print(storage.containsKey('foo')); // false
}
```

Returns the value associated with the specified key before it was removed.

## void **set**(String key, String value)
Associates a given value to the specified key:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();
  print(storage.get('foo')); // null
    
  storage.set('foo', 'bar');
  print(storage.get('foo')); // "bar"
}
```

## void **setObject**(String key, dynamic value)
Serializes and associates a given value to the specified key:

```dart
import 'package:webstorage/webstorage.dart';

void main() {
  final storage = LocalStorage();
  print(storage.getObject('foo')); // null
    
  storage.setObject('foo', {bar: 'baz'});
  print(storage.getObject('foo')); // {bar: "baz"}
}
```

!!! info
    The value is serialized using the [`jsonEncode`](https://api.dart.dev/stable/dart-convert/jsonEncode.html) function.