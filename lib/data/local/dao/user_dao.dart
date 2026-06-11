import 'package:floor/floor.dart';
import 'package:fuelsense/data/local/entity/user_entity.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users')
  Future<List<UserEntity>> getAllUsers();

  @Query('SELECT * FROM users WHERE id = :id')
  Future<UserEntity?> getUserById(int id);

  @insert
  Future<int> createUser(UserEntity user);

  @delete
  Future<void> deleteUser(UserEntity user);

  @update
  Future<void> updateUser(UserEntity user);
}