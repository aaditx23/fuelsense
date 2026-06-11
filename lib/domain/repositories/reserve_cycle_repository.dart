import 'package:fuelsense/domain/entities/reserve_cycle.dart';

abstract class ReserveCycleRepository {
  Future<List<ReserveCycle>> getCyclesByBikeId(int userBikeId);
  Future<ReserveCycle?> getCurrentCycle(int userBikeId);
  Future<ReserveCycle?> getCycleById(int id);
  Future<int> saveCycle(ReserveCycle cycle);
  Future<int> updateCycle(ReserveCycle cycle);
  Future<int> deleteCycle(ReserveCycle cycle);
  Future<int?> addFuelToCycle(int cycleId, double fuelAmount);
  Future<int?> completeCycle(
    int cycleId,
    DateTime endDate,
    double? endTrip,
    double? endOdo,
    double? mileage,
  );
}
