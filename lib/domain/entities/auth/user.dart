import 'package:fuelsense/data/datasources/local/entity/user_entity.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final String? profileImage;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.profileImage,
  });

  UserEntity toEntity(String password) {
    return UserEntity(
      remoteId: id,
      username: username,
      email: email,
      password: password,
      role: role,
      profileImage: profileImage,
    );
  }

  factory User.fromEntity(UserEntity entity) {
    return User(
      id: entity.remoteId,
      username: entity.username,
      email: entity.email,
      role: entity.role,
      profileImage: entity.profileImage,
    );
  }
}
