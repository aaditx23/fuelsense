import 'package:fuelsense/domain/repositories/bike_repository.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';

class SyncPendingBikesUseCase {
  final BikeRepository _bikeRepository;
  final PreferencesRepository _prefs;

  SyncPendingBikesUseCase(this._bikeRepository, this._prefs);

  Future<void> call() async {
    final token = _prefs.getToken();
    if (token == null) throw Exception('No token');

    return await _bikeRepository.syncPendingBikes(token);
  }
}
