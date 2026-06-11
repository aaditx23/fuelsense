import 'package:fuelsense/data/models/bike/bike_response.dart';
import 'package:fuelsense/data/models/bike/bike_request.dart';

abstract class BikeRepository {
  Future<BikeResponse> fetchAllBikes(String token);
  Future<BikeResponse> selectBike(String token, int bikeId);
  Future<BikeResponse> getMyBikes(String token);
  Future<BikeResponse> removeMyBike(String token, int bikeId);
  Future<AddBikeResponse> submitBike(String token, BikeRequest bikeRequest);
  Future<AddBikeResponse> editBike(
    String token,
    BikeRequest bikeRequest,
    int id,
  );
  Future<BikeResponse> getPendingBikes(String token);
  Future<AddBikeResponse> approveBike(String token, int bikeId);
  Future<AddBikeResponse> deleteBike(String token, int bikeId);
}
