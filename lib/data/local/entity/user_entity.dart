/*

 id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    username: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    email: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[str] = mapped_column(String(20), default="user", nullable=False)  # "admin" or "user"
    profile_image: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

 */

import 'package:floor/floor.dart';

@Entity(tableName: "users")
class UserEntity {

  @PrimaryKey(autoGenerate: true)
  int id = 0;
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