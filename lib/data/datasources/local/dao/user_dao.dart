import 'package:hive/hive.dart';
import 'package:fuelsense/data/datasources/local/entity/user_entity.dart';

class UserDao {
  final Box _box;

  UserDao(this._box);

  Future<List<UserEntity>> getAllUsers() async {
    return _box.keys.map((key) {
      final value = _box.get(key);
      return UserEntity.fromJson(Map<String, dynamic>.from(value as Map), key as int);
    }).toList();
  }

  Stream<List<UserEntity>> watchAllUsers() {
    return _box.watch().map((_) {
      return _box.keys.map((key) {
        final value = _box.get(key);
        return UserEntity.fromJson(Map<String, dynamic>.from(value as Map), key as int);
      }).toList();
    });
  }

  Stream<UserEntity?> getUserById(int localId) {
    return _box.watch(key: localId).map((event) {
      final value = _box.get(localId);
      if (value == null) return null;
      return UserEntity.fromJson(Map<String, dynamic>.from(value as Map), localId);
    });
  }

  Future<UserEntity?> getUserByRemoteId(int remoteId) async {
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value != null) {
        final map = Map<String, dynamic>.from(value as Map);
        if (map['remoteId'] == remoteId) {
          return UserEntity.fromJson(map, key as int);
        }
      }
    }
    return null;
  }

  Future<int> createUser(UserEntity user) async {
    final key = await _box.add(user.toJson());
    user.localId = key;
    await _box.put(key, user.toJson());
    return key;
  }

  Future<void> deleteUser(UserEntity user) async {
    if (user.localId != null) {
      await _box.delete(user.localId);
    }
  }

  Future<void> deleteAll() async {
    await _box.clear();
  }

  Future<void> updateUser(UserEntity user) async {
    if (user.localId != null) {
      await _box.put(user.localId, user.toJson());
    }
  }

  Future<void> upsertUser(UserEntity user) async {
    // If localId is null, search by remoteId
    int? localKey = user.localId;
    if (localKey == null) {
      final existing = await getUserByRemoteId(user.remoteId);
      localKey = existing?.localId;
    }

    if (localKey != null) {
      user.localId = localKey;
      await _box.put(localKey, user.toJson());
    } else {
      await createUser(user);
    }
  }
}
