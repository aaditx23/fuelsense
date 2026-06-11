import 'dart:convert';

import 'package:fuelsense/data/models/auth/auth_response.dart';
import 'package:fuelsense/data/models/auth/request.dart';
import 'package:fuelsense/data/datasources/remote/helper.dart';
import 'package:fuelsense/data/datasources/remote/header.dart';
import 'package:http/http.dart' as http;
import 'package:fuelsense/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  Future<AuthResponse> login(LoginRequest loginRequest) async {
    final json = loginRequest.toJson();
    final encodedBody = urlEncodeBody(json);
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login/"),
      body: encodedBody,
      headers: formHeader(),
    );

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final authResponse = AuthResponse.fromJson(jsonResponse);
    authResponse.code = response.statusCode;
    return authResponse;
  }

  Future<AuthResponse> signup(SignupRequest signupRequest) async {
    final json = jsonEncode(signupRequest.toJson());
    print(json);
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register/"),
      body: json,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final authResponse = AuthResponse.fromJson(jsonResponse);
    print("register response");
    print(authResponse);
    authResponse.code = response.statusCode;
    return authResponse;
  }
}
