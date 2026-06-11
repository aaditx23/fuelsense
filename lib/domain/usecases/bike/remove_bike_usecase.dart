import 'package:fuelsense/domain/entities/bike/bike_response.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class RemoveBikeUseCase {
  final BikeRepository repository;
  final PreferencesRepository prefs;

  RemoveBikeUseCase(this.repository, this.prefs);

  Future<BikeResponse> call(int bikeId) async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.removeMyBike(token, bikeId);
  }
}
