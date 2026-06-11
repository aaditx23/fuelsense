import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/data/local/app_database.dart';
import 'package:fuelsense/data/local/dao/name_dao.dart';

Future<void> setupDatabase() async {
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database')
      .build();

  getIt.registerSingleton(database);

  getIt.registerSingleton(database.nameDao);

  getIt.registerSingleton(database.userDao);
}
