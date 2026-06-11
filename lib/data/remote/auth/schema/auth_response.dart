import 'package:fuelsense/data/remote/auth/schema/user_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  bool success;
  String message;
  int? code;
  UserResponse? data;
  String? access_token;

  AuthResponse({
    required this.success,
    required this.message,
    this.code,
    this.data,
    this.access_token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return _$AuthResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AuthResponseToJson(this);
  }
}
