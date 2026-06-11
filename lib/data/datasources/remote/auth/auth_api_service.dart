import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fuelsense/data/datasources/remote/helper.dart';
import 'package:fuelsense/data/datasources/remote/header.dart';
import 'package:fuelsense/data/models/auth/auth_response.dart' as data_auth;
import 'package:fuelsense/data/models/auth/request.dart' as data_request;

class AuthApiService {
  Future<data_auth.AuthResponse> login(
    data_request.LoginRequest loginRequest,
  ) async {
    final json = loginRequest.toJson();
    final encodedBody = urlEncodeBody(json);
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login/"),
      body: encodedBody,
      headers: formHeader(),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final authResponse = data_auth.AuthResponse.fromJson(jsonResponse);
    authResponse.code = response.statusCode;
    return authResponse;
  }

  Future<data_auth.AuthResponse> signup(
    data_request.SignupRequest signupRequest,
  ) async {
    final json = jsonEncode(signupRequest.toJson());
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
    return authResponse;
  }
}
