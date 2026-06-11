import 'package:hive/hive.dart';
import 'package:fuelsense/data/datasources/local/entity/bike_entity.dart';

class BikeDao {
  final Box _box;

  BikeDao(this._box);

  Future<int> insertBike(BikeEntity bike) async {
    final key = await _box.add(bike.toJson());
    bike.localId = key;
    await _box.put(key, bike.toJson());
    return key;
  }

  Future<void> insertBikes(List<BikeEntity> bikes) async {
    for (final bike in bikes) {
      final existing = await getBikeByRemoteId(bike.remoteId);
      if (existing != null) {
        bike.localId = existing.localId;
        await _box.put(existing.localId, bike.toJson());
      } else {
        await insertBike(bike);
      }
    }
  }

  Future<List<BikeEntity>> getAllBikes() async {
    return _box.keys.map((key) {
      final value = _box.get(key);
      return BikeEntity.fromJson(Map<String, dynamic>.from(value as Map), key as int);
    }).toList();
  }

  Future<List<BikeEntity>> getMyBikes() async {
    final bikes = await getAllBikes();
    return bikes.where((b) => b.isMine).toList();
  }

  Future<List<BikeEntity>> getPendingBikes() async {
    final bikes = await getAllBikes();
    return bikes.where((b) => b.isPending).toList();
  }

  Future<List<BikeEntity>> getAllAvailableBikes() async {
    final bikes = await getAllBikes();
    return bikes.where((b) => !b.isPending).toList();
  }

  Future<BikeEntity?> getBikeByLocalId(int localId) async {
    final value = _box.get(localId);
    if (value == null) return null;
    return BikeEntity.fromJson(Map<String, dynamic>.from(value as Map), localId);
  }

  Future<BikeEntity?> getBikeByRemoteId(int remoteId) async {
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value != null) {
        final map = Map<String, dynamic>.from(value as Map);
        if (map['remoteId'] == remoteId) {
          return BikeEntity.fromJson(map, key as int);
        }
      }
    }
    return null;
  }

  Future<void> deleteBikeByRemoteId(int remoteId) async {
    final bike = await getBikeByRemoteId(remoteId);
    if (bike != null && bike.localId != null) {
      await _box.delete(bike.localId);
    }
  }

  Future<void> deleteAllBikes() async {
    await _box.clear();
  }

  Future<int> updateBike(BikeEntity bike) async {
    if (bike.localId != null) {
      await _box.put(bike.localId, bike.toJson());
      return 1;
    }
    final existing = await getBikeByRemoteId(bike.remoteId);
    if (existing != null && existing.localId != null) {
      bike.localId = existing.localId;
      await _box.put(existing.localId, bike.toJson());
      return 1;
    }
    return 0;
  }

  Stream<List<BikeEntity>> watchAllAvailableBikes() {
    return _box.watch().map((_) {
      return _box.keys.map((key) {
        final value = _box.get(key);
        return BikeEntity.fromJson(Map<String, dynamic>.from(value as Map), key as int);
      }).where((b) => !b.isPending).toList();
    });
  }

  Stream<List<BikeEntity>> watchMyBikes() {
    return _box.watch().map((_) {
      return _box.keys.map((key) {
        final value = _box.get(key);
        return BikeEntity.fromJson(Map<String, dynamic>.from(value as Map), key as int);
      }).where((b) => b.isMine).toList();
    });
  }

  Stream<List<BikeEntity>> watchPendingBikes() {
    return _box.watch().map((_) {
      return _box.keys.map((key) {
        final value = _box.get(key);
        return BikeEntity.fromJson(Map<String, dynamic>.from(value as Map), key as int);
      }).where((b) => b.isPending).toList();
    });
  }
}
