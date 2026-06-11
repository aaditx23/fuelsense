import 'package:floor/floor.dart';
import 'package:fuelsense/data/datasources/local/entity/user_entity.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users')
  Future<List<UserEntity>> getAllUsers();

  @Query('SELECT * FROM users WHERE localId = :localId')
  Stream<UserEntity?> getUserById(int localId);

  @Query('SELECT * FROM users WHERE remote_id = :remoteId')
  Future<UserEntity?> getUserByRemoteId(int remoteId);

  @insert
  Future<int> createUser(UserEntity user);

  @delete
  Future<void> deleteUser(UserEntity user);

  @Query("DELETE FROM USERS")
  Future<void> deleteAll();

  @update
  Future<void> updateUser(UserEntity user);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertUser(UserEntity user);
}
