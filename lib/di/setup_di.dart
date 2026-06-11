import 'package:fuelsense/di/database_di.dart';
import 'package:fuelsense/di/repository_di.dart';
import 'package:fuelsense/di/shared_preferences_di.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupDI() async {
  await setupSharedPreferences();
  await setupDatabase();
  setupRepositories();
}
