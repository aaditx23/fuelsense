import 'package:fuelsense/data/models/auth/auth_response.dart';
import 'package:fuelsense/data/models/auth/request.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest loginRequest);
  Future<AuthResponse> signup(SignupRequest signupRequest);
}
