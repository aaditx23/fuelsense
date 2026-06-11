import 'dart:async';
import 'package:floor/floor.dart';
import 'package:fuelsense/data/local/dao/user_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:fuelsense/data/local/dao/name_dao.dart';
import 'package:fuelsense/data/local/entity/name_entity.dart';

import 'entity/user_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [NameEntity, UserEntity])
abstract class AppDatabase extends FloorDatabase {
  NameDao get nameDao;
  UserDao get userDao;
}
