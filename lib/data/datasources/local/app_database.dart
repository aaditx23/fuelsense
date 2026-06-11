import 'dart:async';
import 'package:floor/floor.dart';
import 'package:fuelsense/data/datasources/local/dao/bike_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/pending_operation_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/refuel_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/reserve_cycle_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/bike_entity.dart';
import 'entity/user_entity.dart';
import 'entity/pending_operation_entity.dart';
import 'entity/refuel_entity.dart';
import 'entity/reserve_cycle_entity.dart';

part 'app_database.g.dart';

@Database(
  version: 5,
  entities: [
    UserEntity,
    BikeEntity,
    PendingOperationEntity,
    RefuelEntity,
    ReserveCycleEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  BikeDao get bikeDao;
  PendingOperationDao get pendingOperationDao;
  RefuelDao get refuelDao;
  ReserveCycleDao get reserveCycleDao;
}
