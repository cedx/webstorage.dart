part of "../webstorage.dart";

/// Provides access to the session storage.
class SessionStorage extends WebStorage {

  /// Creates a new storage service.
  SessionStorage({bool listenToGlobalEvents = false}):
    super(window.sessionStorage, listenToGlobalEvents: listenToGlobalEvents);
}
