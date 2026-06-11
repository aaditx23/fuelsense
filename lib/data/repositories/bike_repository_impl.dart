import 'dart:convert';
import 'package:fuelsense/data/datasources/local/entity/bike_entity.dart';
import 'package:fuelsense/data/datasources/remote/bike/bike_api_service.dart';
import 'package:fuelsense/data/mappers/bike_mapper.dart';
import 'package:fuelsense/data/models/base_response.dart';
import 'package:fuelsense/data/models/bike/bike_model.dart' as data_bike;
import 'package:fuelsense/domain/entities/bike/add_bike_response.dart';
import 'package:fuelsense/domain/entities/bike/bike.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/domain/entities/bike/bike_response.dart';
import 'package:fuelsense/data/datasources/local/dao/bike_dao.dart';
import 'package:fuelsense/data/services/sync_manager.dart';
import 'package:fuelsense/data/datasources/local/entity/pending_operation_entity.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class BikeRepositoryImpl implements BikeRepository {
  final BikeDao bikeDao;
  final BikeApiService bikeApiService;
  final SyncManager syncManager;

  BikeRepositoryImpl(this.bikeDao, this.bikeApiService, this.syncManager);

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
  @override
  Future<void> syncAllBikes(String token) async {
    try {
      final bikeResponse = await bikeApiService.syncAllBikes(token);

      // Convert to entities with isMine=false, isPending=false
      final entities =
          bikeResponse.listData
              ?.map(
                (bike) => BikeMapper.toEntityFromDataModel(
                  bike,
                  isMine: false,
                  isPending: false,
                ),
              )
              .toList() ??
          [];

      await _upsertBikes(entities, preserveFlags: true);
    } catch (e) {
      print('Failed to sync all bikes: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> syncMyBikes(String token) async {
    try {
      final bikeResponse = await bikeApiService.syncMyBikes(token);

      // Convert to entities with isMine=true, isPending=false
      final entities =
          bikeResponse.listData
              ?.map(
                (bike) => BikeMapper.toEntityFromDataModel(
                  bike,
                  isMine: true,
                  isPending: false,
                ),
              )
              .toList() ??
          [];

      await _upsertBikes(entities);
    } catch (e) {
      print('Failed to sync my bikes: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> syncPendingBikes(String token) async {
    try {
      // Process any pending operations first (e.g. deletes) before re-fetching
      await syncManager.processPendingOperations();

      final bikeResponse = await bikeApiService.syncPendingBikes(token);

      // Convert to entities with isMine=false, isPending=true
      final entities =
          bikeResponse.listData
              ?.map(
                (bike) => BikeMapper.toEntityFromDataModel(
                  bike,
                  isMine: false,
                  isPending: true,
                ),
              )
              .toList() ??
          [];

      await _upsertBikes(entities);
    } catch (e) {
      print('Failed to sync pending bikes: ${e.toString()}');
      rethrow;
    }
  }

  // Read methods - get from local DB
  @override
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

  @override
  Future<BikeResponse> selectBike(String token, int bikeId) async {
    // Perform optimistic local DB change
    final existing = await bikeDao.getBikeByRemoteId(bikeId);
    if (existing != null) {
      final updatedEntity = existing.copyWith(isMine: true, isPending: false);
      await bikeDao.updateBike(updatedEntity);
    }

    // Enqueue pending operation
    final operation = PendingOperationEntity(
      entityType: 'bike',
      operationType: 'selectBike',
      entityId: bikeId,
      createdAt: DateTime.now().toIso8601String(),
    );
    await syncManager.enqueueOperation(operation);

    // Return success immediately
    return BikeResponse(
      success: true,
      message: 'Bike selected successfully',
      listData: [],
    );
  }

  @override
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

  @override
  Future<BikeResponse> removeMyBike(String token, int bikeId) async {
    // Perform optimistic local DB change
    final existing = await bikeDao.getBikeByRemoteId(bikeId);
    if (existing != null) {
      final updatedEntity = existing.copyWith(isMine: false);
      await bikeDao.updateBike(updatedEntity);
    }

    // Enqueue pending operation
    final operation = PendingOperationEntity(
      entityType: 'bike',
      operationType: 'removeBike',
      entityId: bikeId,
      createdAt: DateTime.now().toIso8601String(),
    );
    await syncManager.enqueueOperation(operation);

    // Return success immediately
    return BikeResponse(
      success: true,
      message: 'Bike removed successfully',
      listData: [],
    );
  }

  @override
  Future<AddBikeResponse> submitBike(
    String token,
    BikeRequest bikeRequest,
  ) async {
    final dataReq = BikeMapper.toDataBikeRequest(bikeRequest);

    // Create local entity with temporary remoteId (-1)
    final localEntity = BikeEntity(
      remoteId: -1, // Temporary ID until server assigns real one
      brand: dataReq.brand,
      model: dataReq.model,
      engineCc: dataReq.engineCc,
      modelYear: dataReq.modelYear,
      fuelType: dataReq.fuelType,
      expectedMileage: dataReq.expectedMileage,
      tankCapacity: dataReq.tankCapacity,
      reserveCapacity: dataReq.reserveCapacity,
      image: dataReq.image,
      isActive: true,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      isMine: false,
      isPending: true,
    );

    final localId = await bikeDao.insertBike(localEntity);

    // Enqueue pending operation
    final operation = PendingOperationEntity(
      entityType: 'bike',
      operationType: 'submitBike',
      localEntityId: localId,
      payload: jsonEncode(dataReq.toJson()),
      createdAt: DateTime.now().toIso8601String(),
    );
    await syncManager.enqueueOperation(operation);

    // Return success immediately with the local entity
    return AddBikeResponse(
      success: true,
      message: 'Bike submitted successfully',
    );
  }

  @override
  Future<AddBikeResponse> editBike(
    String token,
    BikeRequest bikeRequest,
    int id,
  ) async {
    final dataReq = BikeMapper.toDataBikeRequest(bikeRequest);

    // Perform optimistic local DB update
    final existing = await bikeDao.getBikeByRemoteId(id);
    if (existing != null) {
      final updatedEntity = existing.copyWith(
        brand: dataReq.brand,
        model: dataReq.model,
        engineCc: dataReq.engineCc,
        modelYear: dataReq.modelYear,
        fuelType: dataReq.fuelType,
        expectedMileage: dataReq.expectedMileage,
        tankCapacity: dataReq.tankCapacity,
        reserveCapacity: dataReq.reserveCapacity,
        image: dataReq.image,
        updatedAt: DateTime.now().toIso8601String(),
      );
      await bikeDao.updateBike(updatedEntity);
    }

    // Enqueue pending operation
    final operation = PendingOperationEntity(
      entityType: 'bike',
      operationType: 'editBike',
      entityId: id,
      payload: jsonEncode(dataReq.toJson()),
      createdAt: DateTime.now().toIso8601String(),
    );
    await syncManager.enqueueOperation(operation);

    // Return success immediately
    return AddBikeResponse(
      success: true,
      message: 'Bike updated successfully',
      data: existing != null
          ? BikeMapper.toDomainBike(
              data_bike.BikeModel(
                id: existing.remoteId,
                brand: existing.brand,
                model: existing.model,
                engineCc: existing.engineCc,
                modelYear: existing.modelYear,
                fuelType: existing.fuelType,
                expectedMileage: existing.expectedMileage,
                tankCapacity: existing.tankCapacity,
                reserveCapacity: existing.reserveCapacity,
                image: existing.image,
                submittedBy: existing.submittedBy,
                adminNote: existing.adminNote,
                isActive: existing.isActive,
                createdAt: existing.createdAt,
                updatedAt: existing.updatedAt,
                isMine: existing.isMine,
                isPending: existing.isPending,
              ),
            )
          : null,
    );
  }

  @override
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

  @override
  Future<AddBikeResponse> approveBike(String token, int bikeId) async {
    // Perform optimistic local DB change
    final existing = await bikeDao.getBikeByRemoteId(bikeId);
    if (existing != null) {
      final updatedEntity = existing.copyWith(isPending: false);
      await bikeDao.updateBike(updatedEntity);
    }

    // Enqueue pending operation
    final operation = PendingOperationEntity(
      entityType: 'bike',
      operationType: 'approveBike',
      entityId: bikeId,
      createdAt: DateTime.now().toIso8601String(),
    );
    await syncManager.enqueueOperation(operation);

    // Return success immediately
    return AddBikeResponse(
      success: true,
      message: 'Bike approved successfully',
      data: existing != null
          ? BikeMapper.toDomainBike(
              data_bike.BikeModel(
                id: existing.remoteId,
                brand: existing.brand,
                model: existing.model,
                engineCc: existing.engineCc,
                modelYear: existing.modelYear,
                fuelType: existing.fuelType,
                expectedMileage: existing.expectedMileage,
                tankCapacity: existing.tankCapacity,
                reserveCapacity: existing.reserveCapacity,
                image: existing.image,
                submittedBy: existing.submittedBy,
                adminNote: existing.adminNote,
                isActive: existing.isActive,
                createdAt: existing.createdAt,
                updatedAt: existing.updatedAt,
                isMine: existing.isMine,
                isPending: existing.isPending,
              ),
            )
          : null,
    );
  }

  @override
  Future<BaseResponse> deleteBike(String token, int bikeId) async {
    // Optimistically delete the bike from local DB immediately
    final existing = await bikeDao.getBikeByRemoteId(bikeId);
    if (existing != null) {
      await bikeDao.deleteBikeByRemoteId(bikeId);
    }

    // Enqueue pending operation to delete on server
    final operation = PendingOperationEntity(
      entityType: 'bike',
      operationType: 'deleteBike',
      entityId: bikeId,
      createdAt: DateTime.now().toIso8601String(),
    );
    await syncManager.enqueueOperation(operation);

    // Return success immediately
    return BaseResponse(
      success: true,
      message: 'Bike deleted successfully',
    );
  }

  // --- Reactive (Stream) reads ---

  @override
  Stream<List<Bike>> watchAllBikes() {
    return bikeDao
        .watchAllAvailableBikes()
        .map((entities) => entities.map(BikeMapper.toDomainBikeFromEntity).toList());
  }

  @override
  Stream<List<Bike>> watchMyBikes() {
    return bikeDao
        .watchMyBikes()
        .map((entities) => entities.map(BikeMapper.toDomainBikeFromEntity).toList());
  }

  @override
  Stream<List<Bike>> watchPendingBikes() {
    return bikeDao
        .watchPendingBikes()
        .map((entities) => entities.map(BikeMapper.toDomainBikeFromEntity).toList());
  }
}
