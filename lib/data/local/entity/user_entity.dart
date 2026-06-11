
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
  String? profileImage;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.profileImage
});
}