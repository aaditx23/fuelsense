import 'package:floor/floor.dart';

@Entity(tableName: "NAMES")
class NameEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  NameEntity({this.id, required this.name});
}
