part of "../webstorage.dart";

/// Provides access to the [Web Storage](https://developer.mozilla.org/en-US/docs/Web/API/Storage).
abstract class WebStorage extends Object with MapMixin<String, String> { // ignore: prefer_mixin

  /// Creates a new storage service.
  WebStorage(this._backend, {bool listenToGlobalEvents = false}) {
    if (listenToGlobalEvents) _subscription = window.onStorage.listen((event) {
      if (event.storageArea == _backend) _emit(event.key, oldValue: event.oldValue, newValue: event.newValue, url: event.url);
    });
  }

  /// The underlying data store.
  final Storage _backend;

  /// The handler of "changes" events.
  final _onChange = StreamController<StorageEvent>.broadcast();

  /// The subscription to the storage events.
  StreamSubscription<StorageEvent> _subscription;

  /// Value indicating whether there is no key/value pair in this storage.
  @override
  bool get isEmpty => _backend.isEmpty;

  /// Value indicating whether there is at least one key/value pair in this storage.
  @override
  bool get isNotEmpty => _backend.isNotEmpty;

  /// The keys of this storage.
  @override
  Iterable<String> get keys => _backend.keys;

  /// The number of key/value pairs in this storage.
  @override
  int get length => _backend.length;

  /// The stream of "changes" events.
  Stream<StorageEvent> get onChange => _onChange.stream;

  /// Gets the value associated to the specified [key].
  @override
  String operator [](Object key) => get(key);

  /// Associates the [key] with the given [value].
  @override
  void operator []=(String key, String value) => set(key, value);

  /// Removes all pairs from this storage.
  @override
  void clear() {
    _backend.clear();
    _emit(null);
  }

  /// Gets a value indicating whether this storage contains the given [key].
  @override
  bool containsKey(Object key) => _backend.containsKey(key);

  /// Cancels the subscription to the storage events.
  void destroy() => _subscription?.cancel();

  /// Applies the specified function to each key/value pair of this storage.
  @override
  void forEach(void Function(String key, String value) action) => _backend.forEach(action);

  /// Gets the value associated to the specified [key].
  /// Returns the given [defaultValue] if the storage item does not exist.
  String get(String key, [String defaultValue]) => _backend[key] ?? defaultValue;

  /// Gets the deserialized value associated to the specified [key].
  /// Returns the given [defaultValue] if the storage item does not exist.
  dynamic getObject(String key, [defaultValue]) {
    try {
      final value = _backend[key];
      return value != null ? jsonDecode(value) : defaultValue;
    }

    on FormatException {
      return defaultValue;
    }
  }

  /// Looks up the value of the specified [key], or add a new value if it isn't there.
  ///
  /// Returns the deserialized value associated to [key], if there is one.
  /// Otherwise calls [ifAbsent] to get a new value, serializes and associates [key] to that value, and then returns the new value.
  dynamic putObjectIfAbsent(String key, dynamic Function() ifAbsent) {
    if (!containsKey(key)) setObject(key, ifAbsent());
    return getObject(key);
  }

  /// Removes the storage item with the specified [key] and its associated value.
  /// Returns the value associated with [key] before it was removed.
  @override
  String remove(Object key) {
    final oldValue = _backend.remove(key);
    _emit(key, oldValue: oldValue);
    return oldValue;
  }

  /// Associates a given [value] to the specified [key].
  void set(String key, String value) {
    final oldValue = get(key);
    _backend[key] = value;
    _emit(key, oldValue: oldValue, newValue: value);
  }

  /// Serializes and associates a given [value] to the specified [key].
  void setObject(String key, value) => set(key, jsonEncode(value));

  /// Emits a new storage event.
  void _emit(String key, {String oldValue, String newValue, String url}) => _onChange.add(StorageEvent(
    "change",
    key: key,
    newValue: newValue,
    oldValue: oldValue,
    storageArea: _backend,
    url: url ?? window.location.href
  ));
}
