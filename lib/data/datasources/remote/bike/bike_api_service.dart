import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fuelsense/data/datasources/remote/helper.dart';
import 'package:fuelsense/data/datasources/remote/header.dart';
import 'package:fuelsense/data/models/bike/bike_request.dart' as data_request;
import 'package:fuelsense/data/models/bike/bike_response.dart' as data_response;

class BikeApiService {
  // Sync methods
  Future<data_response.BikeResponse> syncAllBikes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bikes/'),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.BikeResponse> syncMyBikes(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/bikes/my-bikes/"),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.BikeResponse> syncPendingBikes(String token) async {
    final response = await http.get(
      (Uri.parse("$baseUrl/admin/bikes/pending/")),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  // CRUD operations
  Future<data_response.BikeResponse> selectBike(
    String token,
    int bikeId,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/bikes/select/"),
      headers: authorizedHeader(token),
      body: jsonEncode({"bikeId": bikeId}),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.BikeResponse> removeMyBike(
    String token,
    int bikeId,
  ) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/bikes/my-bikes/"),
      headers: authorizedHeader(token),
      body: jsonEncode({"bikeId": bikeId}),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return data_response.BikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.AddBikeResponse> submitBike(
    String token,
    data_request.BikeRequest bikeRequest,
  ) async {
    final json = bikeRequest.toJson();
    final response = await http.post(
      Uri.parse("$baseUrl/bikes/submit/"),
      headers: authorizedHeader(token),
      body: jsonEncode(json),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return data_response.AddBikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.AddBikeResponse> editBike(
    String token,
    data_request.BikeRequest bikeRequest,
    int id,
  ) async {
    final json = bikeRequest.toJson();
    final response = await http.put(
      Uri.parse("$baseUrl/admin/bikes/$id/edit/"),
      headers: authorizedHeader(token),
      body: jsonEncode(json),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return data_response.AddBikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.AddBikeResponse> approveBike(
    String token,
    int bikeId,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/admin/bikes/$bikeId/approve/"),
      headers: authorizedHeader(token),
      body: jsonEncode({"bikeId": bikeId}),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return data_response.AddBikeResponse.fromJson(jsonResponse);
  }

  Future<data_response.AddBikeResponse> deleteBike(
    String token,
    int bikeId,
  ) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/bikes/$bikeId/"),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return data_response.AddBikeResponse.fromJson(jsonResponse);
  }
}
