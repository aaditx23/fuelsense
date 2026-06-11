import 'dart:async';
import 'package:floor/floor.dart';
import 'package:fuelsense/data/datasources/local/dao/bike_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/pending_operation_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/bike_entity.dart';
import 'entity/user_entity.dart';
import 'entity/pending_operation_entity.dart';

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [UserEntity, BikeEntity, PendingOperationEntity],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  BikeDao get bikeDao;
  PendingOperationDao get pendingOperationDao;
}
