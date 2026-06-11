class SignupRequest {
  final String username;
  final String email;
  final String password;
  final String? profileImage;
  final String role;

  SignupRequest({
    required this.username,
    required this.email,
    required this.password,
    this.profileImage,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'role': role,
    };
  }
}
