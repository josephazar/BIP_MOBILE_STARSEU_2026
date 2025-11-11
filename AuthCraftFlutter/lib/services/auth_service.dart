import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'secure_storage_service.dart';

/// Authentication service that manages user sessions
class AuthService extends ChangeNotifier {
  final ApiService _apiService;
  final SecureStorageService _storage;

  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthService({
    ApiService? apiService,
    SecureStorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storage = storageService ?? SecureStorageService();

  /// Initialize and check if user is already logged in
  Future<bool> initialize() async {
    try {
      final isLoggedIn = await _storage.isLoggedIn();
      if (isLoggedIn) {
        final userId = await _storage.getUserId();
        if (userId != null) {
          // Fetch user details from backend
          final response = await _apiService.getUserDetails(userId);
          if (response.success && response.result != null) {
            _currentUser = response.result;
            notifyListeners();
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing auth: $e');
      }
      return false;
    }
  }

  /// Register new user
  Future<ApiResponse<User>> register({
    required String name,
    required String mobileNumber,
    required String emailAddress,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    try {
      final response = await _apiService.register(
        name: name,
        mobileNumber: mobileNumber,
        emailAddress: emailAddress,
        password: password,
        confirmPassword: confirmPassword,
      );

      return response;
    } finally {
      _setLoading(false);
    }
  }

  /// Login with email and password
  Future<ApiResponse<User>> login({
    required String emailAddress,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final response = await _apiService.login(
        emailAddress: emailAddress,
        password: password,
      );

      if (response.success && response.result != null) {
        await _saveUserSession(response.result!);
      }

      return response;
    } finally {
      _setLoading(false);
    }
  }

  /// Login with mobile number (sends OTP)
  Future<ApiResponse<User>> loginWithMobile({
    required String mobileNumber,
  }) async {
    _setLoading(true);
    try {
      return await _apiService.loginWithMobile(mobileNumber: mobileNumber);
    } finally {
      _setLoading(false);
    }
  }

  /// Verify OTP
  Future<ApiResponse<User>> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    _setLoading(true);
    try {
      final response = await _apiService.checkOtp(
        mobileNumber: mobileNumber,
        otp: otp,
      );

      if (response.success && response.result != null) {
        await _saveUserSession(response.result!);
      }

      return response;
    } finally {
      _setLoading(false);
    }
  }

  /// Send password reset code
  Future<ApiResponse<User>> sendPasswordResetCode({
    required String emailAddress,
  }) async {
    _setLoading(true);
    try {
      return await _apiService.sendPasswordResetCode(emailAddress: emailAddress);
    } finally {
      _setLoading(false);
    }
  }

  /// Verify password reset code
  Future<ApiResponse<User>> verifyResetCode({
    required String emailAddress,
    required String code,
  }) async {
    _setLoading(true);
    try {
      return await _apiService.checkVerificationCode(
        emailAddress: emailAddress,
        passwordResetCode: code,
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password
  Future<ApiResponse<User>> resetPassword({
    required String emailAddress,
    required String code,
    required String password,
    required String confPassword,
  }) async {
    _setLoading(true);
    try {
      return await _apiService.resetPassword(
        emailAddress: emailAddress,
        passwordResetCode: code,
        password: password,
        confPassword: confPassword,
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Update user profile
  Future<ApiResponse<User>> updateProfile({
    required String name,
    required String mobileNumber,
    required String emailAddress,
  }) async {
    if (_currentUser == null) {
      return ApiResponse(success: false, message: 'User not logged in');
    }

    _setLoading(true);
    try {
      final response = await _apiService.updateUserProfile(
        userId: _currentUser!.id.toString(),
        name: name,
        mobileNumber: mobileNumber,
        emailAddress: emailAddress,
      );

      if (response.success && response.result != null) {
        _currentUser = response.result;
        await _storage.updateUserProfile(
          name: name,
          mobileNumber: mobileNumber,
          emailAddress: emailAddress,
        );
        notifyListeners();
      }

      return response;
    } finally {
      _setLoading(false);
    }
  }

  /// Change password
  Future<ApiResponse<User>> changePassword({
    required String oldPassword,
    required String password,
    required String confPassword,
  }) async {
    if (_currentUser == null) {
      return ApiResponse(success: false, message: 'User not logged in');
    }

    _setLoading(true);
    try {
      return await _apiService.changePassword(
        userId: _currentUser!.id.toString(),
        oldPassword: oldPassword,
        password: password,
        confPassword: confPassword,
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    _currentUser = null;
    await _storage.clearSession();
    notifyListeners();
  }

  /// Save user session to secure storage
  Future<void> _saveUserSession(User user) async {
    _currentUser = user;
    await _storage.saveUserSession(
      userId: user.id.toString(),
      name: user.name,
      mobileNumber: user.mobileNumber,
      emailAddress: user.emailAddress,
    );
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
