import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setupSharedPreferences() async{
  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton(AppSharedPreferences(prefs: prefs));
}