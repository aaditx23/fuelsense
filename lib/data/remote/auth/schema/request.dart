import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

@JsonSerializable()
class LoginRequest {
  String username;
  String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return _$LoginRequestToJson(this);
  }
}

@JsonSerializable()
class SignupRequest {
  String username;
  String email;
  String password;
  String? profile_image;
  String role = "user";

  SignupRequest({
    required this.username,
    required this.email,
    required this.password,
    this.profile_image,
    required this.role,
  });

  Map<String, dynamic> toJson(){
    return _$SignupRequestToJson(this);
  }
}
