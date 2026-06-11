import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuelsense/data/remote/auth/schema/auth_response.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final baseUrl = dotenv.env['API_BASE_URL'];

  Future<AuthResponse> login(LoginRequest loginRequest) async {
    print("loginresponse");
    print(loginRequest.toJson());
    final json = loginRequest.toJson();
    final encodedBody = json.keys
        .map(
          (key) =>
              "${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(json[key]!)}",
        )
        .join("&");
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login/"),
      body: encodedBody,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json',
      },
    );
    print("$baseUrl/auth/login");
    print(response.body);

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    print(jsonResponse);
    final authResponse = AuthResponse.fromJson(jsonResponse);
    authResponse.code = response.statusCode;
    return authResponse;
  }
}
