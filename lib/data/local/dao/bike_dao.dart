import 'package:floor/floor.dart';
import '../entity/bike_entity.dart';

@dao
abstract class BikeDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertBike(BikeEntity bike);

  @Query('SELECT * FROM bikes')
  Future<List<BikeEntity>> getAllBikes();

  @Query('SELECT * FROM bikes WHERE localId = :localId')
  Future<BikeEntity?> getBikeByLocalId(int localId);

  @update
  Future<int> updateBike(BikeEntity bike);
}

