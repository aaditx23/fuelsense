import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final AppSharedPreferences _prefs;

  PreferencesRepositoryImpl(this._prefs);

  @override
  String? getToken() => _prefs.getToken();

  @override
  Future<void> saveToken(String token) => _prefs.saveToken(token);

  @override
  String? getRole() => _prefs.getRole();

  @override
  Future<void> saveRole(String role) => _prefs.saveRole(role);

  @override
  int? getUserId() => _prefs.getUserId();

  @override
  Future<void> saveUserId(int id) => _prefs.saveUserId(id);
}
