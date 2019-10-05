// ignore_for_file: avoid_print
import 'package:webstorage/webstorage.dart';

/// Tests the cookie service.
void main() {
  final storage = LocalStorage();

  // Query the storage.
  print(storage.containsKey('foo')); // false
  print(storage.containsKey('baz')); // false
  print(storage.isEmpty); // true
  print(storage.keys); // []

  // Write to the storage.
  storage['foo'] = 'bar';
  print(storage.containsKey('foo')); // true
  print(storage.length); // 1
  print(storage.keys); // ["foo"]

  storage.setObject('baz', <String, int>{'qux': 123});
  print(storage.containsKey('baz')); // true
  print(storage.length); // 2
  print(storage.keys); // ["foo", "baz"]

  // Read the storage.
  print(storage['foo'].runtimeType); // "String"
  print(storage['foo']); // "bar"

  print(storage.getObject('baz').runtimeType); // "_JsonMap"
  print(storage.getObject('baz')); // {"qux": 123}
  print(storage.getObject('baz')['qux']); // 123

  // Delete from the storage.
  storage.remove('foo');
  print(storage.containsKey('foo')); // false
  print(storage.length); // 1
  print(storage.keys); // ["baz"]

  storage.clear();
  print(storage.containsKey('baz')); // false
  print(storage.isEmpty); // true
  print(storage.keys); // []

  // Release the event listeners.
  storage.destroy();
}
