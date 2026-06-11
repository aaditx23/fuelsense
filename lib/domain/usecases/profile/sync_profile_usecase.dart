import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/profile_repository.dart';

class SyncProfileUseCase {
  final ProfileRepository _profileRepository;
  final PreferencesRepository _prefs;

  SyncProfileUseCase(this._profileRepository, this._prefs);

  Future<void> call() async {
    final token = _prefs.getToken();
    if (token == null) throw Exception('No token');

    return await _profileRepository.syncProfile(token);
  }
}
