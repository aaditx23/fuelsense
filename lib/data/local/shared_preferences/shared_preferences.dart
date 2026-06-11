import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {

  final SharedPreferences prefs;
  final _token = "token";
  final _userId = "userId";

  AppSharedPreferences({required this.prefs});

  Future<void> saveToken(String value) async {
    await prefs.setString(_token, value);
  }
  String? getToken() {
    return prefs.getString(_token);
  }
  Future<void> removeToken() async{
    await prefs.remove(_token);
  }

  Future<void> saveUserId(int value) async {
    await prefs.setInt(_userId, value);
  }

  int? getUserId() {
    return prefs.getInt(_userId);
  }

  Future<void> removeUserId() async{
    await prefs.remove(_userId);
  }



}
