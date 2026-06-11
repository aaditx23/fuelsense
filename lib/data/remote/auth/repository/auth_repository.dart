import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuelsense/data/remote/auth/schema/auth_response.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/data/remote/helper.dart';
import 'package:fuelsense/data/remote/header.dart';
import 'package:http/http.dart' as http;

class AuthRepository {

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
