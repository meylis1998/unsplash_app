import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// {@template secure_storage_helper}
/// A secures storage helper for storing some data need to protect
/// {@endtemplate}
abstract class SecureStorageHelper {
  /// {@macro secure_storage_helper}

  static const _storage = FlutterSecureStorage();

  static Future<String?> readValueByKey(String key) async {
    final result = await _storage.read(key: key);
    return result;
  }

  /// "Write a value to a key in the storage."
  ///
  /// The function is marked as async, which means that it returns a Future
  ///
  /// Args:
  ///
  ///   key (String): The key to store the value under.
  ///
  ///   value (String): The value to be written to the key.
  static Future<void> writeValueToKey({
    required String key,
    String? value,
  }) =>
      _storage.write(key: key, value: value);

  /// Delete the key from the storage
  ///
  /// Args:
  ///   key (String): The key to store the value under.
  static Future<void> deleteKey(String key) => _storage.delete(key: key);

  /// Delete all keys from the storage
  static Future<void> deleteAllKeys() => _storage.deleteAll();

  /// It checks if the key exists in the storage.
  ///
  /// Args:
  ///   key (String): The key to check if it exists.
  static Future<bool> isKeyExist(String key) => _storage.containsKey(key: key);
}
