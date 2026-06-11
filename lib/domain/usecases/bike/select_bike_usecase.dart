import 'package:fuelsense/data/models/bike/bike_response.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class SelectBikeUseCase {
  final BikeRepository repository;
  final AppSharedPreferences prefs;

  SelectBikeUseCase(this.repository, this.prefs);

  Future<BikeResponse> call(int bikeId) async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.selectBike(token, bikeId);
  }
}