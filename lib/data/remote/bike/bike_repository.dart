import 'dart:convert';

import 'package:fuelsense/data/remote/bike/schema/bike_request.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_response.dart';
import 'package:fuelsense/data/remote/header.dart';
import 'package:http/http.dart' as http;

import '../helper.dart';

class BikeRepository {
  Future<BikeResponse> fetchAllBikes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bikes/'),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = BikeResponse.fromJson(jsonResponse);
    return bikeResponse;
  }

  Future<BikeResponse> selectBike(String token, int bikeId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/bikes/select/"),
      headers: authorizedHeader(token),
      body: jsonEncode({"bikeId": bikeId}),
    );

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = BikeResponse.fromJson(jsonResponse);
    return bikeResponse;
  }

  Future<BikeResponse> getMyBikes(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/bikes/my-bikes/"),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = BikeResponse.fromJson(jsonResponse);
    return bikeResponse;
  }

  Future<BikeResponse> removeMyBike(String token, int bikeId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/bikes/my-bikes/"),
      headers: authorizedHeader(token),
      body: jsonEncode({"bikeId": bikeId}),
    );

    print(response.body.isEmpty);
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    print(jsonResponse);
    final bikeResponse = BikeResponse.fromJson(jsonResponse);
    return bikeResponse;
  }

  Future<AddBikeResponse> submitBike(
    String token,
    BikeRequest bikeRequest,
  ) async {
    final json = bikeRequest.toJson();
    final response = await http.post(
      Uri.parse("$baseUrl/bikes/submit/"),
      headers: authorizedHeader(token),
      body: jsonEncode(json),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = AddBikeResponse.fromJson(jsonResponse);
    return bikeResponse;
  }

  Future<BikeResponse> getPendingBikes(String token) async {
    final response = await http.get(
      (Uri.parse("$baseUrl/admin/bikes/pending/")),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = BikeResponse.fromJson(jsonResponse);
    return bikeResponse;
  }
}
