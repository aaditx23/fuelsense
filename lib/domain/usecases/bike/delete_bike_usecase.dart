import 'package:fuelsense/data/models/bike/bike_response.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class DeleteBikeUseCase {
  final BikeRepository repository;
  final AppSharedPreferences prefs;

  DeleteBikeUseCase(this.repository, this.prefs);

  Future<AddBikeResponse> call(int bikeId) async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.deleteBike(token, bikeId);
  }
}