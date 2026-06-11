import 'package:fuelsense/data/models/bike/bike_response.dart';
import 'package:fuelsense/data/models/bike/bike_request.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class SubmitBikeUseCase {
  final BikeRepository repository;
  final AppSharedPreferences prefs;

  SubmitBikeUseCase(this.repository, this.prefs);

  Future<AddBikeResponse> call(BikeRequest bikeRequest) async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.submitBike(token, bikeRequest);
  }
}