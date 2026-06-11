import 'package:fuelsense/data/datasources/local/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  int id;
  String username;
  String email;
  String role;
  String? profileImage;

  UserResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.profileImage,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return _$UserResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserResponseToJson(this);
  }

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
}
