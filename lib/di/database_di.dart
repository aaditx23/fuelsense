import 'package:fuelsense/data/datasources/local/hive_database.dart';
import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/bike_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/refuel_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/reserve_cycle_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/pending_operation_dao.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> setupDatabase() async {
  await initHive();

  getIt.registerSingleton<UserDao>(UserDao(Hive.box('users')));
  getIt.registerSingleton<BikeDao>(BikeDao(Hive.box('bikes')));
  getIt.registerSingleton<RefuelDao>(RefuelDao(Hive.box('fuel_records')));
  getIt.registerSingleton<ReserveCycleDao>(ReserveCycleDao(Hive.box('reserve_cycles')));
  getIt.registerSingleton<PendingOperationDao>(PendingOperationDao(Hive.box('pending_operations')));
}
