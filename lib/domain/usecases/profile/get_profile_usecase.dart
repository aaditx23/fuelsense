import 'package:fuelsense/domain/entities/auth/user.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository profileRepository;
  final PreferencesRepository prefs;

  GetProfileUseCase(this.profileRepository, this.prefs);

  Stream<User?> call() {
    final token = prefs.getToken();
    print("TOKEN:::: $token");
    if (token == null) return Stream.value(null);
    return profileRepository.getProfile(token);
  }
}
