import 'package:fuelsense/data/models/base_response.dart';
import 'package:fuelsense/domain/entities/bike/add_bike_response.dart';
import 'package:fuelsense/domain/entities/bike/bike.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/domain/entities/bike/bike_response.dart';

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
  Future<BaseResponse> deleteBike(String token, int bikeId);
  Future<void> syncAllBikes(String token);
  Future<void> syncMyBikes(String token);
  Future<void> syncPendingBikes(String token);

  // --- Reactive (Stream) reads — equivalent to Room Flow<List<X>> ---
  Stream<List<Bike>> watchAllBikes();
  Stream<List<Bike>> watchMyBikes();
  Stream<List<Bike>> watchPendingBikes();
}
