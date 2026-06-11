import 'package:hive/hive.dart';
import 'package:fuelsense/data/datasources/local/entity/refuel_entity.dart';

class RefuelDao {
  final Box _box;

  RefuelDao(this._box);

  Future<int> insertRefuel(RefuelEntity refuel) async {
    final key = await _box.add(refuel.toJson());
    refuel.localId = key;
    await _box.put(key, refuel.toJson());
    return key;
  }

  Future<int> updateRefuel(RefuelEntity refuel) async {
    if (refuel.localId != null) {
      await _box.put(refuel.localId, refuel.toJson());
      return 1;
    }
    return 0;
  }

  Future<int> deleteRefuel(RefuelEntity refuel) async {
    if (refuel.localId != null) {
      await _box.delete(refuel.localId);
      return 1;
    }
    return 0;
  }

  Future<int?> deleteByRemoteId(int remoteId) async {
    final entity = await findByRemoteId(remoteId);
    if (entity != null && entity.localId != null) {
      await _box.delete(entity.localId);
      return 1;
    }
    return 0;
  }

  Future<List<RefuelEntity>> findAllByUserBikeId(int userBikeId) async {
    final list = <RefuelEntity>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value != null) {
        final map = Map<String, dynamic>.from(value as Map);
        if (map['userBikeId'] == userBikeId) {
          list.add(RefuelEntity.fromJson(map, key as int));
        }
      }
    }
    return list..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Stream<List<RefuelEntity>> watchAllByUserBikeId(int userBikeId) {
    return _box.watch().map((_) {
      final list = <RefuelEntity>[];
      for (final key in _box.keys) {
        final value = _box.get(key);
        if (value != null) {
          final map = Map<String, dynamic>.from(value as Map);
          if (map['userBikeId'] == userBikeId) {
            list.add(RefuelEntity.fromJson(map, key as int));
          }
        }
      }
      return list..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  Future<RefuelEntity?> findByRemoteId(int remoteId) async {
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value != null) {
        final map = Map<String, dynamic>.from(value as Map);
        if (map['remoteId'] == remoteId) {
          return RefuelEntity.fromJson(map, key as int);
        }
      }
    }
    return null;
  }

  Future<RefuelEntity?> findByLocalId(int localId) async {
    final value = _box.get(localId);
    if (value == null) return null;
    return RefuelEntity.fromJson(Map<String, dynamic>.from(value as Map), localId);
  }

  Future<List<RefuelEntity>> findByUserBikeIdAndEntryType(
    int userBikeId,
    String entryType,
  ) async {
    final list = await findAllByUserBikeId(userBikeId);
    return list.where((r) => r.entryType == entryType).toList();
  }

  Future<RefuelEntity?> findIncompleteReserveEntry(int userBikeId) async {
    final list = await findAllByUserBikeId(userBikeId);
    for (final refuel in list) {
      if (refuel.entryType == 'RESERVE_INCOMPLETE') {
        return refuel;
      }
    }
    return null;
  }

  Future<List<RefuelEntity>> findByReserveCycleId(int cycleId) async {
    final list = <RefuelEntity>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value != null) {
        final map = Map<String, dynamic>.from(value as Map);
        if (map['reserveCycleId'] == cycleId) {
          list.add(RefuelEntity.fromJson(map, key as int));
        }
      }
    }
    return list..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<int?> updateEntryTypeAndCycle(
    int localId,
    String entryType,
    int cycleId,
  ) async {
    final refuel = await findByLocalId(localId);
    if (refuel != null) {
      refuel.entryType = entryType;
      refuel.reserveCycleId = cycleId;
      await _box.put(localId, refuel.toJson());
      return 1;
    }
    return 0;
  }

  Future<int?> updateEntryTypeAndClearCycle(int localId, String entryType) async {
    final refuel = await findByLocalId(localId);
    if (refuel != null) {
      refuel.entryType = entryType;
      refuel.reserveCycleId = null;
      await _box.put(localId, refuel.toJson());
      return 1;
    }
    return 0;
  }
}
