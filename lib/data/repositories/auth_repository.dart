import 'package:fuelsense/data/datasources/remote/auth/auth_api_service.dart';
import 'package:fuelsense/data/mappers/auth_mapper.dart';
import 'package:fuelsense/domain/entities/auth/auth_response.dart';
import 'package:fuelsense/domain/entities/auth/login_request.dart';
import 'package:fuelsense/domain/entities/auth/signup_request.dart';
import 'package:fuelsense/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<AuthResponse> login(LoginRequest loginRequest) async {
    final dataReq = AuthMapper.toDataLoginRequest(loginRequest);
    final authResponse = await _authApiService.login(dataReq);
    return AuthMapper.toDomainAuthResponse(authResponse);
  }

  @override
  Future<AuthResponse> signup(SignupRequest signupRequest) async {
    final dataReq = AuthMapper.toDataSignupRequest(signupRequest);
    final authResponse = await _authApiService.signup(dataReq);
    return AuthMapper.toDomainAuthResponse(authResponse);
  }
}
