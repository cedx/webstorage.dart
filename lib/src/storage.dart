part of '../webstorage.dart';

/// Provides access to the [Web Storage](https://developer.mozilla.org/en-US/docs/Web/API/Storage).
abstract class WebStorage extends Object with MapMixin<String, String> { // ignore: prefer_mixin

  /// Creates a new storage service.
  WebStorage(this._backend) {
    _subscription = dom.window.onStorage.listen((event) {
      if (event.key == null || event.storageArea != _backend) return;
      _onChanges.add(<String, SimpleChange>{
        event.key: SimpleChange(previousValue: event.oldValue, currentValue: event.newValue)
      });
    });
  }

  /// The underlying data store.
  final dom.Storage _backend;

  /// The handler of "changes" events.
  final StreamController<Map<String, SimpleChange>> _onChanges = StreamController<Map<String, SimpleChange>>.broadcast();

  /// The subscription to the storage events.
  StreamSubscription<dom.StorageEvent> _subscription;

  /// The keys of the cookies associated with the current document.
  @override
  Iterable<String> get keys => _backend.keys;

  /// The stream of "changes" events.
  Stream<Map<String, SimpleChange>> get onChanges => _onChanges.stream;

  /// Gets the value associated to the specified [key].
  @override
  String operator [](Object key) => get(key);

  /// Associates the [key] with the given [value].
  @override
  void operator []=(String key, String value) => set(key, value);

  /// Removes all cookies associated with the current document.
  @override
  void clear() {
    final changes = <String, SimpleChange>{};
    for (final entry in entries) {
      changes[entry.key] = SimpleChange(previousValue: entry.value);
      _backend.remove(entry.key);
    }

    _onChanges.add(changes);
  }

  /// Cancels the subscription to the storage events.
  void destroy() => _subscription.cancel();

  /// Gets a value indicating whether the current document has a cookie with the specified [key].
  @override
  bool containsKey(Object key) => _backend.containsKey(key);

  /// Gets the value associated to the specified [key].
  /// Returns the given default value if the cookie is not found.
  String get(String key, [String defaultValue]) => containsKey(key) ? _backend[key] : defaultValue;

  /// Gets the deserialized value associated to the specified [key].
  /// Returns the given default value if the cookie is not found.
  dynamic getObject(String key, [defaultValue]) {
    try {
      final value = this[key];
      return value is String ? jsonDecode(value) : defaultValue;
    }

    on FormatException {
      return defaultValue;
    }
  }

  /// Removes the cookie with the specified [key] and its associated value.
  /// Returns the value associated with [key] before it was removed.
  @override
  String remove(Object key) {
    final previousValue = this[key];
    _backend.remove(key);
    _onChanges.add(<String, SimpleChange>{
      key: SimpleChange(previousValue: previousValue)
    });

    return previousValue;
  }

  /// Associates a given [value] to the specified [key].
  void set(String key, String value) {
    final previousValue = this[key];
    _backend[key] = value;
    _onChanges.add(<String, SimpleChange>{
      key: SimpleChange(previousValue: previousValue, currentValue: value)
    });
  }

  /// Serializes and associates a given [value] to the specified [key].
  void setObject(String key, value) => set(key, jsonEncode(value));
}

/// Provides access to the local storage.
class LocalStorage extends WebStorage {

  /// Creates a new storage service.
  LocalStorage(): super(dom.window.localStorage);
}

/// Provides access to the session storage.
class SessionStorage extends WebStorage {

  /// Creates a new storage service.
  SessionStorage(): super(dom.window.sessionStorage);
}