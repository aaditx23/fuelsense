import 'package:fuelsense/data/models/base_response.dart';
import 'package:fuelsense/domain/entities/bike/add_bike_response.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class SubmitBikeUseCase {
  final BikeRepository repository;
  final PreferencesRepository prefs;

  SubmitBikeUseCase(this.repository, this.prefs);

  Future<AddBikeResponse> call(BikeRequest bikeRequest) async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.submitBike(token, bikeRequest);
  }
}
