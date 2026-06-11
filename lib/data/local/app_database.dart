import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:template_flutter/data/local/dao/name_dao.dart';
import 'package:template_flutter/data/local/entity/name_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [NameEntity])
abstract class AppDatabase extends FloorDatabase {
  NameDao get nameDao;
}
