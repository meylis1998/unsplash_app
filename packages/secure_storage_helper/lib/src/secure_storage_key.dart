// ignore_for_file: dangling_library_doc_comments, constant_identifier_names

/// It's a class that contains static constants
/// that represent the keys for the data that we want to
/// store in the secure storage

abstract class SecureStorageKey {
  /// Access token that to access all token required data across the app
  static const access = 'access';

  /// Refresh token that is used to refresh the access and refresh token
  static const refresh = 'refresh';

  /// Current User ID
  static const userID = 'user_id';

  /// Current locale of App
  static const locale = 'locale';

  /// wishlist id
  static const wishlistID = 'wishlist_id';
}
