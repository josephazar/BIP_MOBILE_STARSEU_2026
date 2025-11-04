import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // 🚨 VULNERABILITY #5: Hardcoded Admin Credentials
  // OWASP: M3 - Insecure Authentication/Authorization
  // Risk: Anyone can access admin features with known credentials
  // Solution: Never hardcode credentials, use proper authentication backend
  // Reference: https://docs.talsec.app/appsec-articles/articles/owasp-top-10-for-flutter-m3-insecure-authentication-and-authorization-in-flutter
  static const String _adminUsername = 'admin';
  static const String _adminPassword = 'admin123';

  Future<bool> login(String username, String password, bool rememberMe) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // 🚨 VULNERABILITY #15: Weak Password Hashing (MD5)
    // OWASP: M10 - Insufficient Cryptography
    // Risk: MD5 is cryptographically broken and easy to crack
    // Solution: Use bcrypt, scrypt, or Argon2 for password hashing
    // Reference: https://owasp.org/www-project-mobile-top-10/2023-risks/
    String hashedPassword = md5.convert(utf8.encode(password)).toString();

    // 🚨 VULNERABILITY #3: Debug Logging Sensitive Data
    // OWASP: M1 - Improper Credential Usage
    // Risk: Sensitive data exposed in logs, can be accessed by malware or debugging tools
    // Solution: Never log sensitive information, use proper logging levels
    // Reference: https://docs.talsec.app/appsec-articles/articles/owasp-top-10-for-flutter-m1-mastering-credential-security-in-flutter
    print('🔓 Login attempt for user: $username');
    print('🔑 Password hash: $hashedPassword');

    bool loginSuccess = false;
    bool isAdminUser = false;

    // Check for hardcoded admin credentials
    if (username == _adminUsername && password == _adminPassword) {
      loginSuccess = true;
      isAdminUser = true;
      print('👑 Admin login successful!');
    } else if (username.isNotEmpty && password.isNotEmpty) {
      // Accept any non-empty credentials for demo purposes
      loginSuccess = true;
      print('✅ Regular user login successful!');
    }

    if (loginSuccess) {
      // Generate a fake JWT token
      String token = 'jwt_token_${DateTime.now().millisecondsSinceEpoch}_$username';

      // 🚨 VULNERABILITY #3 (continued): Logging sensitive token
      print('🎫 Generated token: $token');

      _currentUser = User(
        username: username,
        token: token,
        isAdmin: isAdminUser,
      );

      // 🚨 VULNERABILITY #2: Insecure Token Storage
      // OWASP: M1 - Improper Credential Usage
      // Risk: Token stored in plain text in SharedPreferences, easily accessible
      // Solution: Use flutter_secure_storage for sensitive data
      // Reference: https://docs.talsec.app/appsec-articles/articles/owasp-top-10-for-flutter-m1-mastering-credential-security-in-flutter
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('username', username);
      await prefs.setBool('is_admin', isAdminUser);

      // 🚨 VULNERABILITY #13: Plain Text Password Storage
      // OWASP: M9 - Insecure Data Storage
      // Risk: Password stored in plain text for "Remember Me" feature
      // Solution: Never store passwords, use secure token-based authentication
      // Reference: https://owasp.org/www-project-mobile-top-10/2023-risks/
      if (rememberMe) {
        await prefs.setString('saved_password', password);
        await prefs.setString('saved_username', username);
        print('💾 Password saved for Remember Me feature');
      }
    }

    _isLoading = false;
    notifyListeners();
    return loginSuccess;
  }

  Future<void> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');
    
    if (savedToken != null) {
      final username = prefs.getString('username') ?? '';
      final isAdminUser = prefs.getBool('is_admin') ?? false;
      
      _currentUser = User(
        username: username,
        token: savedToken,
        isAdmin: isAdminUser,
      );
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');
    await prefs.remove('is_admin');
    // Note: We deliberately don't remove saved_password to demonstrate the vulnerability
    
    _currentUser = null;
    notifyListeners();
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('saved_username');
    final savedPassword = prefs.getString('saved_password');
    
    if (savedUsername != null && savedPassword != null) {
      return {
        'username': savedUsername,
        'password': savedPassword,
      };
    }
    return null;
  }
}
