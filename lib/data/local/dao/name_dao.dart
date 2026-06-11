import 'package:floor/floor.dart';
import 'package:template_flutter/data/local/entity/name_entity.dart';

@dao
abstract class NameDao {
  @Query("SELECT * FROM NAMES")
  Future<List<NameEntity>> getNames();

  @insert
  Future<void> createName(NameEntity name);
}
