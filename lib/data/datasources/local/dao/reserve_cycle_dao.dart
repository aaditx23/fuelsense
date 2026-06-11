import 'package:floor/floor.dart';
import 'package:fuelsense/data/datasources/local/entity/reserve_cycle_entity.dart';

@dao
abstract class ReserveCycleDao {
  @Query(
    'SELECT * FROM reserve_cycles WHERE userBikeId = :userBikeId ORDER BY cycleStartDate DESC',
  )
  Future<List<ReserveCycleEntity>> findAllByUserBikeId(int userBikeId);

  @Query(
    'SELECT * FROM reserve_cycles WHERE userBikeId = :userBikeId AND isComplete = 0 ORDER BY cycleStartDate DESC LIMIT 1',
  )
  Future<ReserveCycleEntity?> findCurrentCycle(int userBikeId);

  @Query('SELECT * FROM reserve_cycles WHERE id = :id')
  Future<ReserveCycleEntity?> findById(int id);

  @insert
  Future<int> insertReserveCycle(ReserveCycleEntity reserveCycle);

  @update
  Future<int> updateReserveCycle(ReserveCycleEntity reserveCycle);

  @delete
  Future<int> deleteReserveCycle(ReserveCycleEntity reserveCycle);

  @Query(
    'UPDATE reserve_cycles SET totalFuelAdded = totalFuelAdded + :fuelAmount WHERE id = :cycleId',
  )
  Future<int?> addFuelToCycle(int cycleId, double fuelAmount);

  @Query(
    'UPDATE reserve_cycles SET isComplete = 1, cycleEndDate = :endDate, endTripReading = :endTrip, endOdometerReading = :endOdo, calculatedMileage = :mileage WHERE id = :cycleId',
  )
  Future<int?> completeCycleWithAllData(
    int cycleId,
    int endDate,
    double endTrip,
    double endOdo,
    double mileage,
  );

  @Query(
    'UPDATE reserve_cycles SET isComplete = 1, cycleEndDate = :endDate, endTripReading = :endTrip, endOdometerReading = :endOdo, calculatedMileage = NULL WHERE id = :cycleId',
  )
  Future<int?> completeCycleWithoutMileage(
    int cycleId,
    int endDate,
    double endTrip,
    double endOdo,
  );

  @Query(
    'UPDATE reserve_cycles SET isComplete = 1, cycleEndDate = :endDate, endTripReading = NULL, endOdometerReading = NULL, calculatedMileage = NULL WHERE id = :cycleId',
  )
  Future<int?> completeCycleMinimal(int cycleId, int endDate);
}
