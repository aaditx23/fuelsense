import 'package:fuelsense/data/models/auth/auth_response.dart' as data_auth;
import 'package:fuelsense/data/models/auth/request.dart' as data_request;
import 'package:fuelsense/data/models/user/user_response.dart' as data_user;
import 'package:fuelsense/domain/entities/auth/auth_response.dart';
import 'package:fuelsense/domain/entities/auth/login_request.dart';
import 'package:fuelsense/domain/entities/auth/signup_request.dart';
import 'package:fuelsense/domain/entities/auth/user.dart';

class AuthMapper {
  static data_request.LoginRequest toDataLoginRequest(LoginRequest domain) {
    return data_request.LoginRequest(
      username: domain.username,
      password: domain.password,
    );
  }

  static data_request.SignupRequest toDataSignupRequest(SignupRequest domain) {
    return data_request.SignupRequest(
      username: domain.username,
      email: domain.email,
      password: domain.password,
      profileImage: domain.profileImage,
      role: domain.role,
    );
  }

  static User toDomainUser(data_user.UserResponse data) {
    return User(
      id: data.id,
      username: data.username,
      email: data.email,
      role: data.role,
      profileImage: data.profileImage,
    );
  }

  static AuthResponse toDomainAuthResponse(data_auth.AuthResponse data) {
    return AuthResponse(
      success: data.success,
      message: data.message,
      code: data.code,
      data: data.data != null ? toDomainUser(data.data!) : null,
      token: data.token,
    );
  }
}
