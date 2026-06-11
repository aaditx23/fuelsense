import 'package:floor/floor.dart';

@Entity(
  tableName: "users",
  indices: [
    Index(value: ['remote_id'], unique: true),
  ],
)
class UserEntity {
  @PrimaryKey(autoGenerate: true)
  int? localId;
  @ColumnInfo(name: 'remote_id')
  int remoteId;
  String username;
  String email;
  String password;
  String role;
  String? profileImage;

  UserEntity({
    this.localId,
    required this.remoteId,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.profileImage,
  });

  UserEntity copyWith({
    int? localId,
    int? remoteId,
    String? username,
    String? email,
    String? password,
    String? role,
    String? profileImage,
  }) {
    return UserEntity(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
