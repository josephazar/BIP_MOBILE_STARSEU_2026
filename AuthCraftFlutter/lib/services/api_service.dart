import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

/// API Service for backend communication
/// Implements OWASP security practices for mobile apps
class ApiService {
  // TODO: Update this URL to match your backend server
  // For Android emulator, use 10.0.2.2 instead of localhost
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1';

  // HTTP client with timeout configuration
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Common headers for API requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };

  /// Register new user
  Future<ApiResponse<User>> register({
    required String name,
    required String mobileNumber,
    required String emailAddress,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/register'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'mobile_number': mobileNumber,
              'email_address': emailAddress,
              'password': password,
              'confirmPassword': confirmPassword,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Login with email and password
  Future<ApiResponse<User>> login({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/login'),
            headers: _headers,
            body: jsonEncode({
              'email_address': emailAddress,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Login with mobile number (sends OTP)
  Future<ApiResponse<User>> loginWithMobile({
    required String mobileNumber,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/login_with_mobile'),
            headers: _headers,
            body: jsonEncode({
              'mobile_number': mobileNumber,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Verify OTP for mobile login
  Future<ApiResponse<User>> checkOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/check_otp'),
            headers: _headers,
            body: jsonEncode({
              'mobile_number': mobileNumber,
              'otp': otp,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Send password reset code to email
  Future<ApiResponse<User>> sendPasswordResetCode({
    required String emailAddress,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/send_password_reset_code'),
            headers: _headers,
            body: jsonEncode({
              'email_address': emailAddress,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Verify password reset code
  Future<ApiResponse<User>> checkVerificationCode({
    required String emailAddress,
    required String passwordResetCode,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/check_verification_code'),
            headers: _headers,
            body: jsonEncode({
              'email_address': emailAddress,
              'password_reset_code': passwordResetCode,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Reset password
  Future<ApiResponse<User>> resetPassword({
    required String emailAddress,
    required String passwordResetCode,
    required String password,
    required String confPassword,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/reset_password'),
            headers: _headers,
            body: jsonEncode({
              'email_address': emailAddress,
              'password_reset_code': passwordResetCode,
              'password': password,
              'confPassword': confPassword,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Get user details
  Future<ApiResponse<User>> getUserDetails(String userId) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$baseUrl/user_details/$userId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<ApiResponse<User>> updateUserProfile({
    required String userId,
    required String name,
    required String mobileNumber,
    required String emailAddress,
  }) async {
    try {
      final response = await _client
          .put(
            Uri.parse('$baseUrl/user_update/$userId'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'mobile_number': mobileNumber,
              'email_address': emailAddress,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Change password
  Future<ApiResponse<User>> changePassword({
    required String userId,
    required String oldPassword,
    required String password,
    required String confPassword,
  }) async {
    try {
      final response = await _client
          .put(
            Uri.parse('$baseUrl/change_password/$userId'),
            headers: _headers,
            body: jsonEncode({
              'old_password': oldPassword,
              'password': password,
              'confPassword': confPassword,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse<User>(response, (json) => User.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: 'Network error: ${e.toString()}');
    }
  }

  /// Handle API response and parse JSON
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic) fromJson,
  ) {
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse<T>.fromJson(jsonResponse, fromJson);
    } else {
      return ApiResponse(
        success: false,
        message: 'Server error: ${response.statusCode}',
      );
    }
  }

  /// Dispose HTTP client
  void dispose() {
    _client.close();
  }
}
