import 'package:flutter_template/di/database_di.dart';
import 'package:flutter_template/di/repository_di.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupDI() async {
  await setupDatabase();
  setupRepositories();
}
