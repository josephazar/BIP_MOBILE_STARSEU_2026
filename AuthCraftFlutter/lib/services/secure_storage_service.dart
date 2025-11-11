import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service using Android Keychain/Keystore
/// This service handles all sensitive data storage operations
class SecureStorageService {
  // Create storage instance with secure options
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      // Uses AES encryption and stores keys in Android Keystore
    ),
  );

  // Storage keys
  static const String _keyUserId = 'user_id';
  static const String _keyName = 'name';
  static const String _keyMobileNumber = 'mobile_number';
  static const String _keyEmailAddress = 'email_address';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Save user session data securely
  Future<void> saveUserSession({
    required String userId,
    required String name,
    required String mobileNumber,
    required String emailAddress,
  }) async {
    await Future.wait([
      _storage.write(key: _keyUserId, value: userId),
      _storage.write(key: _keyName, value: name),
      _storage.write(key: _keyMobileNumber, value: mobileNumber),
      _storage.write(key: _keyEmailAddress, value: emailAddress),
      _storage.write(key: _keyIsLoggedIn, value: 'true'),
    ]);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Get user name
  Future<String?> getName() async {
    return await _storage.read(key: _keyName);
  }

  /// Get mobile number
  Future<String?> getMobileNumber() async {
    return await _storage.read(key: _keyMobileNumber);
  }

  /// Get email address
  Future<String?> getEmailAddress() async {
    return await _storage.read(key: _keyEmailAddress);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _keyIsLoggedIn);
    return value == 'true';
  }

  /// Clear all stored data (logout)
  Future<void> clearSession() async {
    await _storage.deleteAll();
  }

  /// Update user profile data
  Future<void> updateUserProfile({
    required String name,
    required String mobileNumber,
    required String emailAddress,
  }) async {
    await Future.wait([
      _storage.write(key: _keyName, value: name),
      _storage.write(key: _keyMobileNumber, value: mobileNumber),
      _storage.write(key: _keyEmailAddress, value: emailAddress),
    ]);
  }
}
