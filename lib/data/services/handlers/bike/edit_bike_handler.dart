import 'dart:convert';
import 'package:fuelsense/data/datasources/remote/bike/bike_api_service.dart';
import 'package:fuelsense/data/datasources/local/dao/bike_dao.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/models/bike/bike_request.dart' as data_request;
import 'package:fuelsense/data/datasources/local/entity/pending_operation_entity.dart';
import '../../operation_handler.dart';

class EditBikeHandler implements OperationHandler {
  final BikeApiService _bikeApiService;
  final BikeDao _bikeDao;
  final AppSharedPreferences _prefs;

  EditBikeHandler(this._bikeApiService, this._bikeDao, this._prefs);

  @override
  Future<void> execute(PendingOperationEntity operation) async {
    print(
      '[EditBikeHandler] Starting execution for operation ID: ${operation.id}',
    );

    final token = _prefs.getToken();
    if (token == null) {
      print('[EditBikeHandler] ERROR: No auth token available');
      throw Exception('No auth token available');
    }
    print('[EditBikeHandler] Auth token retrieved');

    final payload = operation.payload;
    if (payload == null) {
      print('[EditBikeHandler] ERROR: No payload in operation');
      throw Exception('payload is required for editBike operation');
    }
    print('[EditBikeHandler] Payload: $payload');

    final entityId = operation.entityId;
    if (entityId == null) {
      print('[EditBikeHandler] ERROR: No entityId in operation');
      throw Exception('entityId is required for editBike operation');
    }
    print('[EditBikeHandler] Entity ID: $entityId');

    // Deserialize the payload
    final Map<String, dynamic> requestData = jsonDecode(payload);
    final bikeRequest = data_request.BikeRequest.fromJson(requestData);
    print('[EditBikeHandler] Request deserialized: ${requestData.toString()}');

    // Call the API
    print('[EditBikeHandler] Calling API editBike...');
    final response = await _bikeApiService.editBike(
      token,
      bikeRequest,
      entityId,
    );
    print(
      '[EditBikeHandler] API Response - Success: ${response.success}, Message: ${response.message}',
    );
    print(
      '[EditBikeHandler] API Response - Data: ${response.data?.toJson().toString()}',
    );

    if (response.success == true && response.data != null) {
      print('[EditBikeHandler] Updating local entity with server response');
      final localEntity = await _bikeDao.getBikeByRemoteId(entityId);
      if (localEntity != null) {
        final updatedEntity = localEntity.copyWith(
          brand: response.data!.brand,
          model: response.data!.model,
          engineCc: response.data!.engineCc,
          modelYear: response.data!.modelYear,
          fuelType: response.data!.fuelType,
          expectedMileage: response.data!.expectedMileage,
          tankCapacity: response.data!.tankCapacity,
          reserveCapacity: response.data!.reserveCapacity,
          image: response.data!.image,
          submittedBy: response.data!.submittedBy,
          adminNote: response.data!.adminNote,
          isActive: response.data!.isActive,
          updatedAt: response.data!.updatedAt,
        );
        await _bikeDao.updateBike(updatedEntity);
        print('[EditBikeHandler] Local entity updated successfully');
      } else {
        print(
          '[EditBikeHandler] WARNING: Local entity not found for remoteId: $entityId',
        );
      }
      print('[EditBikeHandler] Operation completed successfully');
    } else {
      print('[EditBikeHandler] ERROR: Server rejected bike edit');
      throw Exception('Server rejected bike edit: ${response.message}');
    }
  }
}
