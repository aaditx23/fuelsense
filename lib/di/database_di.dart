import 'package:flutter_template/di/setup_di.dart';
import 'package:flutter_template/data/local/app_database.dart';
import 'package:flutter_template/data/local/dao/name_dao.dart';

Future<void> setupDatabase() async{
  final database = await $FloorAppDatabase
  .databaseBuilder('app_database')
  .build();

  getIt.registerSingleton<AppDatabase>(database);

  getIt.registerSingleton<NameDao>(database.nameDao);

} 