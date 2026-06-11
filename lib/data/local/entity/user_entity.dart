
import 'package:floor/floor.dart';

@Entity(tableName: "users")
class UserEntity {

  @PrimaryKey(autoGenerate: true)
  int? id;
  String username;
  String email;
  String password;
  String role;
  String? profile_image;

  UserEntity({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.profile_image
});
}