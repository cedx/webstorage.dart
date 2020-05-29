// ignore_for_file: avoid_print
import "package:webstorage/webstorage.dart";

/// Tests the cookie service.
void main() {
	final service = LocalStorage();

	// Query the storage.
	print(service.containsKey("foo")); // false
	print(service.containsKey("baz")); // false
	print(service.isEmpty); // true
	print(service.keys); // []

	// Write to the storage.
	service["foo"] = "bar";
	print(service.containsKey("foo")); // true
	print(service.length); // 1
	print(service.keys); // ["foo"]

	service.setObject("baz", {"qux": 123});
	print(service.containsKey("baz")); // true
	print(service.length); // 2
	print(service.keys); // ["foo", "baz"]

	// Read the storage.
	print(service["foo"].runtimeType); // "String"
	print(service["foo"]); // "bar"

	print(service.getObject("baz").runtimeType); // "_JsonMap"
	print(service.getObject("baz")); // {"qux": 123}
	print(service.getObject("baz")["qux"]); // 123

	// Iterate the storage.
	for (final entry in service.entries) print("${entry.key} => ${entry.value}");

	// Delete from the storage.
	service.remove("foo");
	print(service.containsKey("foo")); // false
	print(service.length); // 1
	print(service.keys); // ["baz"]

	service.clear();
	print(service.containsKey("baz")); // false
	print(service.isEmpty); // true
	print(service.keys); // []

	// Release the event listeners.
	service.destroy();
}
