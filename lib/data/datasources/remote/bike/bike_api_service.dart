import 'package:dio/dio.dart';
import 'package:fuelsense/data/models/base_response.dart';
import 'package:fuelsense/data/datasources/remote/dio_client.dart';
import 'package:fuelsense/data/models/bike/bike_request.dart' as data_request;
import 'package:fuelsense/data/models/bike/bike_response.dart' as data_response;

class BikeApiService {
  final Dio _dio;

  BikeApiService(this._dio);

  // Sync methods
  Future<data_response.BikeResponse> syncAllBikes(String token) async {
    final response = await _dio.get(
      '/bikes/',
      options: authOptions(token),
    );
    final jsonResponse = response.data as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.BikeResponse> syncMyBikes(String token) async {
    final response = await _dio.get(
      '/bikes/my-bikes/',
      options: authOptions(token),
    );
    final jsonResponse = response.data as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.BikeResponse> syncPendingBikes(String token) async {
    final response = await _dio.get(
      '/admin/bikes/pending/',
      options: authOptions(token),
    );
    final jsonResponse = response.data as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  // CRUD operations
  Future<data_response.BikeResponse> selectBike(
    String token,
    int bikeId,
  ) async {
    final response = await _dio.put(
      '/bikes/select/',
      data: {"bikeId": bikeId},
      options: authOptions(token),
    );
    final jsonResponse = response.data as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.BikeResponse> removeMyBike(
    String token,
    int bikeId,
  ) async {
    final response = await _dio.delete(
      '/bikes/my-bikes/',
      data: {"bikeId": bikeId},
      options: authOptions(token),
    );
    final jsonResponse = response.data as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.AddBikeResponse> submitBike(
    String token,
    data_request.BikeRequest bikeRequest,
  ) async {
    final response = await _dio.post(
      '/bikes/submit/',
      data: bikeRequest.toJson(),
      options: authOptions(token),
    );
    final jsonResponse = response.data as Map<String, dynamic>;
    return data_response.AddBikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.AddBikeResponse> editBike(
    String token,
    data_request.BikeRequest bikeRequest,
    int id,
  ) async {
    final response = await _dio.put(
      '/admin/bikes/$id/edit/',
      data: bikeRequest.toJson(),
      options: authOptions(token),
    );
    final jsonResponse = response.data as Map<String, dynamic>;
    return data_response.AddBikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.AddBikeResponse> approveBike(
    String token,
    int bikeId,
  ) async {
    final response = await _dio.put(
      '/admin/bikes/$bikeId/approve/',
      data: {"bikeId": bikeId},
      options: authOptions(token),
    );
    final jsonResponse = response.data as Map<String, dynamic>;
    return data_response.AddBikeResponse.fromJson(jsonResponse);
  }

  Future<BaseResponse> deleteBike(String token, int bikeId) async {
    final response = await _dio.delete(
      '/admin/bikes/$bikeId/',
      options: authOptions(token),
    );
    final jsonResponse = response.data as Map<String, dynamic>;
    return BaseResponse.fromJson(jsonResponse);
  }
}
