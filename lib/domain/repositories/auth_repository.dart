import 'package:fuelsense/domain/entities/auth/auth_response.dart';
import 'package:fuelsense/domain/entities/auth/login_request.dart';
import 'package:fuelsense/domain/entities/auth/signup_request.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest loginRequest);
  Future<AuthResponse> signup(SignupRequest signupRequest);
}
