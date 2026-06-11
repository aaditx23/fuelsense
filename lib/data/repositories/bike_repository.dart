import 'dart:convert';

import 'package:fuelsense/data/datasources/remote/helper.dart';
import 'package:fuelsense/data/mappers/bike_mapper.dart';
import 'package:fuelsense/data/models/bike/bike_request.dart' as data_request;
import 'package:fuelsense/data/models/bike/bike_response.dart' as data_response;
import 'package:fuelsense/data/datasources/remote/header.dart';
import 'package:fuelsense/domain/entities/bike/add_bike_response.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/domain/entities/bike/bike_response.dart';
import 'package:http/http.dart' as http;

import '../../domain/repositories/bike_repository.dart';

class BikeRepositoryImpl implements BikeRepository {
  Future<BikeResponse> fetchAllBikes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bikes/'),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = data_response.BikeResponse.fromJson(jsonResponse);
    return BikeMapper.toDomainBikeResponse(bikeResponse);
  }

  Future<BikeResponse> selectBike(String token, int bikeId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/bikes/select/"),
      headers: authorizedHeader(token),
      body: jsonEncode({"bikeId": bikeId}),
    );

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = data_response.BikeResponse.fromJson(jsonResponse);
    return BikeMapper.toDomainBikeResponse(bikeResponse);
  }

  Future<BikeResponse> getMyBikes(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/bikes/my-bikes/"),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = data_response.BikeResponse.fromJson(jsonResponse);
    return BikeMapper.toDomainBikeResponse(bikeResponse);
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
    final bikeResponse = data_response.BikeResponse.fromJson(jsonResponse);
    return BikeMapper.toDomainBikeResponse(bikeResponse);
  }

  Future<AddBikeResponse> submitBike(
    String token,
    BikeRequest bikeRequest,
  ) async {
    final dataReq = BikeMapper.toDataBikeRequest(bikeRequest);
    final json = dataReq.toJson();
    final response = await http.post(
      Uri.parse("$baseUrl/bikes/submit/"),
      headers: authorizedHeader(token),
      body: jsonEncode(json),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = data_response.AddBikeResponse.fromJson(jsonResponse);
    return BikeMapper.toDomainAddBikeResponse(bikeResponse);
  }

  Future<AddBikeResponse> editBike(
    String token,
    BikeRequest bikeRequest,
    int id,
  ) async {
    final dataReq = BikeMapper.toDataBikeRequest(bikeRequest);
    final json = dataReq.toJson();
    final response = await http.put(
      Uri.parse("$baseUrl/admin/bikes/$id/edit/"),
      headers: authorizedHeader(token),
      body: jsonEncode(json),
    );
    print(response.body.toString());
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = data_response.AddBikeResponse.fromJson(jsonResponse);
    return BikeMapper.toDomainAddBikeResponse(bikeResponse);
  }

  Future<BikeResponse> getPendingBikes(String token) async {
    final response = await http.get(
      (Uri.parse("$baseUrl/admin/bikes/pending/")),
      headers: authorizedHeader(token),
    );
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = data_response.BikeResponse.fromJson(jsonResponse);
    return BikeMapper.toDomainBikeResponse(bikeResponse);
  }

  Future<AddBikeResponse> approveBike(String token, int bikeId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/admin/bikes/$bikeId/approve/"),
      headers: authorizedHeader(token),
      body: jsonEncode({"bikeId": bikeId}),
    );

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final bikeResponse = data_response.AddBikeResponse.fromJson(jsonResponse);
    return BikeMapper.toDomainAddBikeResponse(bikeResponse);
  }

  Future<AddBikeResponse> deleteBike(String token, int bikeId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/bikes/$bikeId/"),
      headers: authorizedHeader(token),
    );

    print(response.body.toString());
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    jsonResponse["data"] = null;
    final bikeResponse = data_response.AddBikeResponse.fromJson(jsonResponse);
    return BikeMapper.toDomainAddBikeResponse(bikeResponse);
  }
}
