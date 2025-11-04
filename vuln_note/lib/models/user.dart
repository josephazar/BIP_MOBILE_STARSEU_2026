class User {
  final String username;
  final String token;
  final bool isAdmin;

  User({
    required this.username,
    required this.token,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'token': token,
      'isAdmin': isAdmin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      token: map['token'] as String,
      isAdmin: map['isAdmin'] as bool? ?? false,
    );
  }
}
