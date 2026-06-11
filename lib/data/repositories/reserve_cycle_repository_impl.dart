import 'package:fuelsense/data/datasources/local/dao/reserve_cycle_dao.dart';
import 'package:fuelsense/domain/entities/reserve_cycle.dart';
import 'package:fuelsense/domain/repositories/reserve_cycle_repository.dart';

class ReserveCycleRepositoryImpl implements ReserveCycleRepository {
  final ReserveCycleDao _reserveCycleDao;

  ReserveCycleRepositoryImpl(this._reserveCycleDao);

  @override
  Future<List<ReserveCycle>> getCyclesByBikeId(int userBikeId) async {
    final entities = await _reserveCycleDao.findAllByUserBikeId(userBikeId);
    return entities.map((entity) => ReserveCycle.fromEntity(entity)).toList();
  }

  @override
  Future<ReserveCycle?> getCurrentCycle(int userBikeId) async {
    final entity = await _reserveCycleDao.findCurrentCycle(userBikeId);
    return entity != null ? ReserveCycle.fromEntity(entity) : null;
  }

  @override
  Future<ReserveCycle?> getCycleById(int id) async {
    final entity = await _reserveCycleDao.findById(id);
    return entity != null ? ReserveCycle.fromEntity(entity) : null;
  }

  @override
  Future<int> saveCycle(ReserveCycle cycle) async {
    return await _reserveCycleDao.insertReserveCycle(cycle.toEntity());
  }

  @override
  Future<int> updateCycle(ReserveCycle cycle) async {
    return await _reserveCycleDao.updateReserveCycle(cycle.toEntity());
  }

  @override
  Future<int> deleteCycle(ReserveCycle cycle) async {
    return await _reserveCycleDao.deleteReserveCycle(cycle.toEntity());
  }

  @override
  Future<int?> addFuelToCycle(int cycleId, double fuelAmount) async {
    return await _reserveCycleDao.addFuelToCycle(cycleId, fuelAmount);
  }

  @override
  Future<int?> completeCycle(
    int cycleId,
    DateTime endDate,
    double? endTrip,
    double? endOdo,
    double? mileage,
  ) async {
    final endDateMillis = endDate.millisecondsSinceEpoch;

    if (endTrip != null && endOdo != null && mileage != null) {
      return await _reserveCycleDao.completeCycleWithAllData(
        cycleId,
        endDateMillis,
        endTrip,
        endOdo,
        mileage,
      );
    } else if (endTrip != null && endOdo != null) {
      return await _reserveCycleDao.completeCycleWithoutMileage(
        cycleId,
        endDateMillis,
        endTrip,
        endOdo,
      );
    } else {
      return await _reserveCycleDao.completeCycleMinimal(
        cycleId,
        endDateMillis,
      );
    }
  }
}
