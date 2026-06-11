import 'package:fuelsense/data/models/bike/bike_request.dart';
import 'package:fuelsense/data/models/bike/bike_response.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class EditBikeUseCase {
  final BikeRepository repository;
  final AppSharedPreferences prefs;

  EditBikeUseCase(this.repository, this.prefs);

  Future<AddBikeResponse> call(int id, BikeRequest bikeRequest) async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.editBike(token, bikeRequest, id);
  }
}