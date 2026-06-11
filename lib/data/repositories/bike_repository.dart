import 'package:fuelsense/data/datasources/local/entity/bike_entity.dart';
import 'package:fuelsense/data/datasources/remote/bike/bike_api_service.dart';
import 'package:fuelsense/data/mappers/bike_mapper.dart';
import 'package:fuelsense/domain/entities/bike/add_bike_response.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/domain/entities/bike/bike_response.dart';
import 'package:fuelsense/data/datasources/local/dao/bike_dao.dart';

import '../../domain/repositories/bike_repository.dart';

class BikeRepositoryImpl implements BikeRepository {
  final BikeDao bikeDao;
  final BikeApiService bikeApiService;

  BikeRepositoryImpl(this.bikeDao, this.bikeApiService);

  // Helper method to upsert bikes (insert or update based on remoteId)
  Future<void> _upsertBikes(
    List<BikeEntity> entities, {
    bool preserveFlags = false,
  }) async {
    for (final entity in entities) {
      final existing = await bikeDao.getBikeByRemoteId(entity.remoteId);
      if (existing != null) {
        // Update existing bike
        final updatedEntity = preserveFlags
            ? entity.copyWith(
                localId: existing.localId,
                isMine: existing.isMine,
                isPending: existing.isPending,
              )
            : entity.copyWith(localId: existing.localId);
        await bikeDao.updateBike(updatedEntity);
      } else {
        // Insert new bike
        await bikeDao.insertBike(entity);
      }
    }
  }

  // Sync methods - fetch from API and store in local DB
  Future<void> syncAllBikes(String token) async {
    try {
      final bikeResponse = await bikeApiService.syncAllBikes(token);

      // Convert to entities with isMine=false, isPending=false
      final entities =
          bikeResponse.listData
              ?.map(
                (bike) => BikeEntity(
                  remoteId: bike.id,
                  brand: bike.brand,
                  model: bike.model,
                  engineCc: bike.engineCc,
                  modelYear: bike.modelYear,
                  fuelType: bike.fuelType,
                  expectedMileage: bike.expectedMileage,
                  tankCapacity: bike.tankCapacity,
                  reserveCapacity: bike.reserveCapacity,
                  image: bike.image,
                  submittedBy: bike.submittedBy,
                  adminNote: bike.adminNote,
                  isActive: bike.isActive,
                  createdAt: bike.createdAt,
                  updatedAt: bike.updatedAt,
                  isMine: false,
                  isPending: false,
                ),
              )
              .toList() ??
          [];

      await _upsertBikes(entities, preserveFlags: true);
    } catch (e) {
      // If sync fails, we don't throw - let the caller handle it
      // The offline-first approach means we should still show local data
      print('Failed to sync all bikes: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> syncMyBikes(String token) async {
    try {
      final bikeResponse = await bikeApiService.syncMyBikes(token);

      // Convert to entities with isMine=true, isPending=false
      final entities =
          bikeResponse.listData
              ?.map(
                (bike) => BikeEntity(
                  remoteId: bike.id,
                  brand: bike.brand,
                  model: bike.model,
                  engineCc: bike.engineCc,
                  modelYear: bike.modelYear,
                  fuelType: bike.fuelType,
                  expectedMileage: bike.expectedMileage,
                  tankCapacity: bike.tankCapacity,
                  reserveCapacity: bike.reserveCapacity,
                  image: bike.image,
                  submittedBy: bike.submittedBy,
                  adminNote: bike.adminNote,
                  isActive: bike.isActive,
                  createdAt: bike.createdAt,
                  updatedAt: bike.updatedAt,
                  isMine: true,
                  isPending: false,
                ),
              )
              .toList() ??
          [];

      await _upsertBikes(entities);
    } catch (e) {
      // If sync fails, we don't throw - let the caller handle it
      // The offline-first approach means we should still show local data
      print('Failed to sync my bikes: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> syncPendingBikes(String token) async {
    try {
      final bikeResponse = await bikeApiService.syncPendingBikes(token);

      // Convert to entities with isMine=false, isPending=true
      final entities =
          bikeResponse.listData
              ?.map(
                (bike) => BikeEntity(
                  remoteId: bike.id,
                  brand: bike.brand,
                  model: bike.model,
                  engineCc: bike.engineCc,
                  modelYear: bike.modelYear,
                  fuelType: bike.fuelType,
                  expectedMileage: bike.expectedMileage,
                  tankCapacity: bike.tankCapacity,
                  reserveCapacity: bike.reserveCapacity,
                  image: bike.image,
                  submittedBy: bike.submittedBy,
                  adminNote: bike.adminNote,
                  isActive: bike.isActive,
                  createdAt: bike.createdAt,
                  updatedAt: bike.updatedAt,
                  isMine: false,
                  isPending: true,
                ),
              )
              .toList() ??
          [];

      await _upsertBikes(entities);
    } catch (e) {
      // If sync fails, we don't throw - let the caller handle it
      // The offline-first approach means we should still show local data
      print('Failed to sync pending bikes: ${e.toString()}');
      rethrow;
    }
  }

  // Read methods - get from local DB
  Future<BikeResponse> fetchAllBikes(String token) async {
    try {
      final entities = await bikeDao.getAllAvailableBikes();
      final bikes = entities.map(BikeMapper.toDomainBikeFromEntity).toList();
      return BikeResponse(
        success: true,
        message: 'Bikes fetched from local database',
        listData: bikes,
      );
    } catch (e) {
      return BikeResponse(
        success: false,
        message: 'Failed to fetch bikes from local database: ${e.toString()}',
        listData: [],
      );
    }
  }

  Future<BikeResponse> selectBike(String token, int bikeId) async {
    final bikeResponse = await bikeApiService.selectBike(token, bikeId);

    // Update local database flags after successful API call
    if (bikeResponse.success == true) {
      final existing = await bikeDao.getBikeByRemoteId(bikeId);
      if (existing != null) {
        final updatedEntity = existing.copyWith(isMine: true, isPending: false);
        await bikeDao.updateBike(updatedEntity);
      }
    }

    return BikeMapper.toDomainBikeResponse(bikeResponse);
  }

  Future<BikeResponse> getMyBikes(String token) async {
    try {
      final entities = await bikeDao.getMyBikes();
      final bikes = entities.map(BikeMapper.toDomainBikeFromEntity).toList();
      return BikeResponse(
        success: true,
        message: 'My bikes fetched from local database',
        listData: bikes,
      );
    } catch (e) {
      return BikeResponse(
        success: false,
        message:
            'Failed to fetch my bikes from local database: ${e.toString()}',
        listData: [],
      );
    }
  }

  Future<BikeResponse> removeMyBike(String token, int bikeId) async {
    final bikeResponse = await bikeApiService.removeMyBike(token, bikeId);

    // Update local database flags after successful API call
    if (bikeResponse.success == true) {
      final existing = await bikeDao.getBikeByRemoteId(bikeId);
      if (existing != null) {
        final updatedEntity = existing.copyWith(isMine: false);
        await bikeDao.updateBike(updatedEntity);
      }
    }

    return BikeMapper.toDomainBikeResponse(bikeResponse);
  }

  Future<AddBikeResponse> submitBike(
    String token,
    BikeRequest bikeRequest,
  ) async {
    final dataReq = BikeMapper.toDataBikeRequest(bikeRequest);
    final bikeResponse = await bikeApiService.submitBike(token, dataReq);
    return BikeMapper.toDomainAddBikeResponse(bikeResponse);
  }

  Future<AddBikeResponse> editBike(
    String token,
    BikeRequest bikeRequest,
    int id,
  ) async {
    final dataReq = BikeMapper.toDataBikeRequest(bikeRequest);
    final bikeResponse = await bikeApiService.editBike(token, dataReq, id);
    return BikeMapper.toDomainAddBikeResponse(bikeResponse);
  }

  Future<BikeResponse> getPendingBikes(String token) async {
    try {
      final entities = await bikeDao.getPendingBikes();
      final bikes = entities.map(BikeMapper.toDomainBikeFromEntity).toList();
      return BikeResponse(
        success: true,
        message: 'Pending bikes fetched from local database',
        listData: bikes,
      );
    } catch (e) {
      return BikeResponse(
        success: false,
        message:
            'Failed to fetch pending bikes from local database: ${e.toString()}',
        listData: [],
      );
    }
  }

  Future<AddBikeResponse> approveBike(String token, int bikeId) async {
    final bikeResponse = await bikeApiService.approveBike(token, bikeId);

    // Update local database flags after successful API call
    if (bikeResponse.success == true) {
      final existing = await bikeDao.getBikeByRemoteId(bikeId);
      if (existing != null) {
        final updatedEntity = existing.copyWith(isPending: false);
        await bikeDao.updateBike(updatedEntity);
      }
    }

    return BikeMapper.toDomainAddBikeResponse(bikeResponse);
  }

  Future<AddBikeResponse> deleteBike(String token, int bikeId) async {
    final bikeResponse = await bikeApiService.deleteBike(token, bikeId);

    // Remove from local database after successful API call
    if (bikeResponse.success == true) {
      await bikeDao.deleteBikeByRemoteId(bikeId);
    }

    return BikeMapper.toDomainAddBikeResponse(bikeResponse);
  }
}
