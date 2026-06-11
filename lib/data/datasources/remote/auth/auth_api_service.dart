import 'package:dio/dio.dart';
import 'package:fuelsense/data/models/auth/auth_response.dart' as data_auth;
import 'package:fuelsense/data/models/auth/request.dart' as data_request;

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<data_auth.AuthResponse> login(
    data_request.LoginRequest loginRequest,
  ) async {
    final response = await _dio.post(
      "/auth/login/",
      data: {
        'username': loginRequest.username,
        'password': loginRequest.password,
      },
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
      ),
    );

    final Map<String, dynamic> jsonResponse = response.data as Map<String, dynamic>;
    final authResponse = data_auth.AuthResponse.fromJson(jsonResponse);
    authResponse.code = response.statusCode;
    return authResponse;
  }

  Future<data_auth.AuthResponse> signup(
    data_request.SignupRequest signupRequest,
  ) async {
    final response = await _dio.post(
      "/auth/register/",
      data: signupRequest.toJson(),
    );

    final Map<String, dynamic> jsonResponse = response.data as Map<String, dynamic>;
    final authResponse = data_auth.AuthResponse.fromJson(jsonResponse);
    authResponse.code = response.statusCode;
    return authResponse;
  }
}
