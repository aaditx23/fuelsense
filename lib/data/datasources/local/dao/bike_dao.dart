import 'package:floor/floor.dart';
import '../entity/bike_entity.dart';

@dao
abstract class BikeDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertBike(BikeEntity bike);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertBikes(List<BikeEntity> bikes);

  @Query('SELECT * FROM bikes')
  Future<List<BikeEntity>> getAllBikes();

  @Query('SELECT * FROM bikes WHERE isMine = 1')
  Future<List<BikeEntity>> getMyBikes();

  @Query('SELECT * FROM bikes WHERE isPending = 1')
  Future<List<BikeEntity>> getPendingBikes();

  @Query('SELECT * FROM bikes WHERE isPending = 0')
  Future<List<BikeEntity>> getAllAvailableBikes();

  @Query('SELECT * FROM bikes WHERE localId = :localId')
  Future<BikeEntity?> getBikeByLocalId(int localId);

  @Query('SELECT * FROM bikes WHERE remoteId = :remoteId')
  Future<BikeEntity?> getBikeByRemoteId(int remoteId);

  @Query('DELETE FROM bikes WHERE remoteId = :remoteId')
  Future<void> deleteBikeByRemoteId(int remoteId);

  @Query('DELETE FROM bikes')
  Future<void> deleteAllBikes();

  @update
  Future<int> updateBike(BikeEntity bike);
}
