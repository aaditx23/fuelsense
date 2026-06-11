import 'package:fuelsense/domain/entities/bike/bike_response.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class GetPendingBikesUseCase {
  final BikeRepository repository;
  final PreferencesRepository prefs;

  GetPendingBikesUseCase(this.repository, this.prefs);

  Future<BikeResponse> call() async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.getPendingBikes(token);
  }
}
