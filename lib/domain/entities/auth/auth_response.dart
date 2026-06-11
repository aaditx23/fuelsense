import 'package:fuelsense/domain/entities/auth/user.dart';

class AuthResponse {
  final bool success;
  final String message;
  final int? code;
  final User? data;
  final String? token;

  AuthResponse({
    required this.success,
    required this.message,
    this.code,
    this.data,
    this.token,
  });
}
