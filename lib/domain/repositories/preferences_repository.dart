abstract class PreferencesRepository {
  String? getToken();
  Future<void> saveToken(String token);
  String? getRole();
  int? getUserId();
  Future<void> saveUserId(int id);
  Future<void> saveRole(String role);
}
