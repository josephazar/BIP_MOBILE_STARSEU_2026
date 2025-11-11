/// User data model
class User {
  final int id;
  final String name;
  final String mobileNumber;
  final String emailAddress;
  final String? password;
  final String? otp;
  final String? passwordResetCode;

  User({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.emailAddress,
    this.password,
    this.otp,
    this.passwordResetCode,
  });

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      emailAddress: json['email_address'] ?? '',
      password: json['password'],
      otp: json['otp'],
      passwordResetCode: json['password_reset_code'],
    );
  }

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile_number': mobileNumber,
      'email_address': emailAddress,
      if (password != null) 'password': password,
      if (otp != null) 'otp': otp,
      if (passwordResetCode != null) 'password_reset_code': passwordResetCode,
    };
  }
}

/// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? result;

  ApiResponse({
    required this.success,
    required this.message,
    this.result,
  });

  /// Create ApiResponse from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: json['result'] != null && fromJsonT != null
          ? fromJsonT(json['result'])
          : null,
    );
  }
}
