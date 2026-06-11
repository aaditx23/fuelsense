import 'package:fuelsense/data/datasources/local/app_database.dart';
import 'package:fuelsense/di/setup_di.dart';

Future<void> setupDatabase() async {
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database')
      .build();

  getIt.registerSingleton(database);

  getIt.registerSingleton(database.userDao);

  getIt.registerSingleton(database.bikeDao);

  getIt.registerSingleton(database.pendingOperationDao);
}
