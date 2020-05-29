part of "../webstorage.dart";

/// Provides access to the local storage.
class LocalStorage extends WebStorage {

  /// Creates a new storage service.
  LocalStorage({bool listenToGlobalEvents = false}):
    super(window.localStorage, listenToGlobalEvents: listenToGlobalEvents);
}
