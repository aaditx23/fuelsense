import 'package:floor/floor.dart';
import 'package:fuelsense/data/datasources/local/entity/refuel_entity.dart';

@dao
abstract class RefuelDao {
  @Query(
    'SELECT * FROM fuel_records WHERE userBikeId = :userBikeId ORDER BY createdAt DESC',
  )
  Future<List<RefuelEntity>> findAllByUserBikeId(int userBikeId);

  @Query(
    'SELECT * FROM fuel_records WHERE userBikeId = :userBikeId ORDER BY createdAt DESC',
  )
  Stream<List<RefuelEntity>> watchAllByUserBikeId(int userBikeId);

  @Query('SELECT * FROM fuel_records WHERE remoteId = :remoteId')
  Future<RefuelEntity?> findByRemoteId(int remoteId);

  @Query('SELECT * FROM fuel_records WHERE localId = :localId')
  Future<RefuelEntity?> findByLocalId(int localId);

  @Query(
    'SELECT * FROM fuel_records WHERE userBikeId = :userBikeId AND entryType = :entryType ORDER BY createdAt DESC',
  )
  Future<List<RefuelEntity>> findByUserBikeIdAndEntryType(
    int userBikeId,
    String entryType,
  );

  @Query(
    'SELECT * FROM fuel_records WHERE userBikeId = :userBikeId AND entryType = "RESERVE_INCOMPLETE" ORDER BY createdAt DESC LIMIT 1',
  )
  Future<RefuelEntity?> findIncompleteReserveEntry(int userBikeId);

  @Query(
    'SELECT * FROM fuel_records WHERE reserveCycleId = :cycleId ORDER BY createdAt ASC',
  )
  Future<List<RefuelEntity>> findByReserveCycleId(int cycleId);

  @insert
  Future<int> insertRefuel(RefuelEntity refuel);

  @update
  Future<int> updateRefuel(RefuelEntity refuel);

  @delete
  Future<int> deleteRefuel(RefuelEntity refuel);

  @Query('DELETE FROM fuel_records WHERE remoteId = :remoteId')
  Future<int?> deleteByRemoteId(int remoteId);

  @Query(
    'UPDATE fuel_records SET entryType = :entryType, reserveCycleId = :cycleId WHERE localId = :localId',
  )
  Future<int?> updateEntryTypeAndCycle(
    int localId,
    String entryType,
    int cycleId,
  );

  @Query(
    'UPDATE fuel_records SET entryType = :entryType, reserveCycleId = NULL WHERE localId = :localId',
  )
  Future<int?> updateEntryTypeAndClearCycle(int localId, String entryType);
}
