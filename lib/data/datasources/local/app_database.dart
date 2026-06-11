import 'dart:async';
import 'package:floor/floor.dart';
import 'package:fuelsense/data/datasources/local/dao/bike_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/bike_entity.dart';
import 'entity/user_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [UserEntity, BikeEntity])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  BikeDao get bikeDao;
}
