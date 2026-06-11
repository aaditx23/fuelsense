import 'package:fuelsense/data/local/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  int id;
  String username;
  String email;
  String role;
  String? profile_image;

  UserResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.profile_image,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return _$UserResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserResponseToJson(this);
  }

  UserEntity toEntity(String password){
    return UserEntity(
        id: id,
        username: username,
        email: email,
        password: password,
        role: role,
        profile_image: profile_image
    );
  }
}
