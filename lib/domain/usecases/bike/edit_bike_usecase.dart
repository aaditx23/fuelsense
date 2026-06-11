import 'package:fuelsense/domain/entities/bike/add_bike_response.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class EditBikeUseCase {
  final BikeRepository repository;
  final PreferencesRepository prefs;

  EditBikeUseCase(this.repository, this.prefs);

  Future<AddBikeResponse> call(int id, BikeRequest bikeRequest) async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.editBike(token, bikeRequest, id);
  }
}
