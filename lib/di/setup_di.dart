import 'package:template_flutter/di/database_di.dart';
import 'package:template_flutter/di/repository_di.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupDI() async {
  await setupDatabase();
  setupRepositories();
}
