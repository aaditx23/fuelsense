import 'package:hive/hive.dart';
import 'package:fuelsense/data/datasources/local/entity/reserve_cycle_entity.dart';

class ReserveCycleDao {
  final Box _box;

  ReserveCycleDao(this._box);

  Future<int> insertReserveCycle(ReserveCycleEntity reserveCycle) async {
    final key = await _box.add(reserveCycle.toJson());
    reserveCycle.id = key;
    await _box.put(key, reserveCycle.toJson());
    return key;
  }

  Future<int> updateReserveCycle(ReserveCycleEntity reserveCycle) async {
    if (reserveCycle.id != null) {
      await _box.put(reserveCycle.id, reserveCycle.toJson());
      return 1;
    }
    return 0;
  }

  Future<int> deleteReserveCycle(ReserveCycleEntity reserveCycle) async {
    if (reserveCycle.id != null) {
      await _box.delete(reserveCycle.id);
      return 1;
    }
    return 0;
  }

  Future<List<ReserveCycleEntity>> findAllByUserBikeId(int userBikeId) async {
    final list = <ReserveCycleEntity>[];
    for (final key in _box.keys) {
      final value = _box.get(key);
      if (value != null) {
        final map = Map<String, dynamic>.from(value as Map);
        if (map['userBikeId'] == userBikeId) {
          list.add(ReserveCycleEntity.fromJson(map, key as int));
        }
      }
    }
    return list..sort((a, b) => b.cycleStartDate.compareTo(a.cycleStartDate));
  }

  Future<ReserveCycleEntity?> findCurrentCycle(int userBikeId) async {
    final list = await findAllByUserBikeId(userBikeId);
    for (final cycle in list) {
      if (!cycle.isComplete) {
        return cycle;
      }
    }
    return null;
  }

  Future<ReserveCycleEntity?> findById(int id) async {
    final value = _box.get(id);
    if (value == null) return null;
    return ReserveCycleEntity.fromJson(Map<String, dynamic>.from(value as Map), id);
  }

  Future<int?> addFuelToCycle(int cycleId, double fuelAmount) async {
    final cycle = await findById(cycleId);
    if (cycle != null) {
      cycle.totalFuelAdded += fuelAmount;
      await _box.put(cycleId, cycle.toJson());
      return 1;
    }
    return 0;
  }

  Future<int?> completeCycleWithAllData(
    int cycleId,
    int endDate,
    double endTrip,
    double endOdo,
    double mileage,
  ) async {
    final cycle = await findById(cycleId);
    if (cycle != null) {
      cycle.isComplete = true;
      cycle.cycleEndDate = endDate;
      cycle.endTripReading = endTrip;
      cycle.endOdometerReading = endOdo;
      cycle.calculatedMileage = mileage;
      await _box.put(cycleId, cycle.toJson());
      return 1;
    }
    return 0;
  }

  Future<int?> completeCycleWithoutMileage(
    int cycleId,
    int endDate,
    double endTrip,
    double endOdo,
  ) async {
    final cycle = await findById(cycleId);
    if (cycle != null) {
      cycle.isComplete = true;
      cycle.cycleEndDate = endDate;
      cycle.endTripReading = endTrip;
      cycle.endOdometerReading = endOdo;
      cycle.calculatedMileage = null;
      await _box.put(cycleId, cycle.toJson());
      return 1;
    }
    return 0;
  }

  Future<int?> completeCycleMinimal(int cycleId, int endDate) async {
    final cycle = await findById(cycleId);
    if (cycle != null) {
      cycle.isComplete = true;
      cycle.cycleEndDate = endDate;
      cycle.endTripReading = null;
      cycle.endOdometerReading = null;
      cycle.calculatedMileage = null;
      await _box.put(cycleId, cycle.toJson());
      return 1;
    }
    return 0;
  }
}
