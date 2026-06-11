import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

/*
-d 'grant_type=password&username=user%40fuelsense.com&password=user123&scope=&client_id=&client_secret='
*/
@JsonSerializable()
class LoginRequest {
  String username;
  String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return _$LoginRequestToJson(this);
  }
}

class SignupRequest {
  String name;
  String email;
  String password;
  String? profileImage;
  String role = "user";

  SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    this.profileImage,
    required this.role,
  });
}
