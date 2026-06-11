
import 'package:floor/floor.dart';

@Entity(tableName: "users")
class UserEntity {

  @PrimaryKey(autoGenerate: true)
  int? localId;
  int id;
  String username;
  String email;
  String password;
  String role;
  String? profile_image;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.profile_image
});
}