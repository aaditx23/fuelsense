import 'package:template_flutter/di/setup_di.dart';
import 'package:template_flutter/data/local/app_database.dart';
import 'package:template_flutter/data/local/dao/name_dao.dart';

Future<void> setupDatabase() async {
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database')
      .build();

  getIt.registerSingleton<AppDatabase>(database);

  getIt.registerSingleton<NameDao>(database.nameDao);
}
