import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Dio buildDioClient() {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  return dio;
}

Options authOptions(String token) =>
    Options(headers: {'Authorization': 'Bearer $token'});
