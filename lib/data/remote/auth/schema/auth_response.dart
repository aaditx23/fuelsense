import 'package:fuelsense/data/remote/auth/schema/user_response.dart';
import 'package:fuelsense/data/remote/schema/base_response.dart';

import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse extends BaseResponse {
  int? code;
  UserResponse? data;
  String? token;

  AuthResponse({
    required super.success,
    required super.message,
    this.code,
    this.data,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return _$AuthResponseFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$AuthResponseToJson(this);
  }
}
