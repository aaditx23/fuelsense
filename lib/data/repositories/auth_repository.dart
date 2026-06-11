import 'dart:convert';

import 'package:fuelsense/data/mappers/auth_mapper.dart';
import 'package:fuelsense/data/models/auth/auth_response.dart' as data_auth;
import 'package:fuelsense/data/models/auth/request.dart' as data_request;
import 'package:fuelsense/data/datasources/remote/helper.dart';
import 'package:fuelsense/data/datasources/remote/header.dart';
import 'package:fuelsense/domain/entities/auth/auth_response.dart';
import 'package:fuelsense/domain/entities/auth/login_request.dart';
import 'package:fuelsense/domain/entities/auth/signup_request.dart';
import 'package:http/http.dart' as http;
import 'package:fuelsense/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  Future<AuthResponse> login(LoginRequest loginRequest) async {
    final dataReq = AuthMapper.toDataLoginRequest(loginRequest);
    final json = dataReq.toJson();
    final encodedBody = urlEncodeBody(json);
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login/"),
      body: encodedBody,
      headers: formHeader(),
    );

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final authResponse = data_auth.AuthResponse.fromJson(jsonResponse);
    authResponse.code = response.statusCode;
    return AuthMapper.toDomainAuthResponse(authResponse);
  }

  Future<AuthResponse> signup(SignupRequest signupRequest) async {
    final dataReq = AuthMapper.toDataSignupRequest(signupRequest);
    final json = jsonEncode(dataReq.toJson());
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register/"),
      body: json,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final authResponse = data_auth.AuthResponse.fromJson(jsonResponse);
    authResponse.code = response.statusCode;
    return AuthMapper.toDomainAuthResponse(authResponse);
  }
}
