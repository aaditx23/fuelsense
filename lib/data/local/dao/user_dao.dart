import 'package:floor/floor.dart';
import 'package:fuelsense/data/local/entity/user_entity.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users')
  Future<List<UserEntity>> getAllUsers();

  @Query('SELECT * FROM users WHERE localId = :localId')
  Future<UserEntity?> getUserById(int localId);

  @insert
  Future<int> createUser(UserEntity user);

  @delete
  Future<void> deleteUser(UserEntity user);

  @Query("DELETE FROM USERS")
  Future<void> deleteAll();

  @update
  Future<void> updateUser(UserEntity user);
}
