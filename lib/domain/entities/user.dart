class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String role;
  final String? profileImage;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.profileImage,
  });
}
