import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {

  final SharedPreferences prefs;

  AppSharedPreferences({required this.prefs});

  Future<void> saveToken(String value) async {
    await prefs.setString('token', value);
  }

  String? getToken() {
    return prefs.getString('token');
  }

  Future<void> saveUserId(int value) async {
    await prefs.setInt('userId', value);
  }

  int? getUserId() {
    return prefs.getInt('userId');
  }


}
