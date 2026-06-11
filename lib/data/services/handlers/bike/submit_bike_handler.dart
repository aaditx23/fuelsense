import 'dart:convert';
import 'package:fuelsense/data/datasources/remote/bike/bike_api_service.dart';
import 'package:fuelsense/data/datasources/local/dao/bike_dao.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/models/bike/bike_request.dart' as data_request;
import 'package:fuelsense/data/datasources/local/entity/pending_operation_entity.dart';
import '../../operation_handler.dart';

class SubmitBikeHandler implements OperationHandler {
  final BikeApiService _bikeApiService;
  final BikeDao _bikeDao;
  final AppSharedPreferences _prefs;

  SubmitBikeHandler(this._bikeApiService, this._bikeDao, this._prefs);

  @override
  Future<void> execute(PendingOperationEntity operation) async {
    print(
      '[SubmitBikeHandler] Starting execution for operation ID: ${operation.id}',
    );

    final token = _prefs.getToken();
    if (token == null) {
      print('[SubmitBikeHandler] ERROR: No auth token available');
      throw Exception('No auth token available');
    }
    print('[SubmitBikeHandler] Auth token retrieved');

    final payload = operation.payload;
    if (payload == null) {
      print('[SubmitBikeHandler] ERROR: No payload in operation');
      throw Exception('payload is required for submitBike operation');
    }
    print('[SubmitBikeHandler] Payload: $payload');

    final localEntityId = operation.localEntityId;
    if (localEntityId == null) {
      print('[SubmitBikeHandler] ERROR: No localEntityId in operation');
      throw Exception('localEntityId is required for submitBike operation');
    }
    print('[SubmitBikeHandler] Local Entity ID: $localEntityId');

    // Deserialize the payload
    final Map<String, dynamic> requestData = jsonDecode(payload);
    final bikeRequest = data_request.BikeRequest.fromJson(requestData);
    print(
      '[SubmitBikeHandler] Request deserialized: ${requestData.toString()}',
    );

    // Call the API
    print('[SubmitBikeHandler] Calling API submitBike...');
    final response = await _bikeApiService.submitBike(token, bikeRequest);
    print(
      '[SubmitBikeHandler] API Response - Success: ${response.success}, Message: ${response.message} ID: ${response.data!.id}',
    );

    if (response.success && response.data != null) {
      print(
        '[SubmitBikeHandler] Updating local entity with remoteId: ${response.data!.id}',
      );
      final localEntity = await _bikeDao.getBikeByLocalId(localEntityId);
      if (localEntity != null) {
        final updatedEntity = localEntity.copyWith(remoteId: response.data!.id);
        await _bikeDao.updateBike(updatedEntity);
        print('[SubmitBikeHandler] Local entity updated successfully');
      } else {
        print(
          '[SubmitBikeHandler] WARNING: Local entity not found for localId: $localEntityId',
        );
      }
      print('[SubmitBikeHandler] Operation completed successfully');
    } else {
      print('[SubmitBikeHandler] ERROR: Server rejected bike submission');
      throw Exception('Server rejected bike submission: ${response.message}');
    }
  }
}
