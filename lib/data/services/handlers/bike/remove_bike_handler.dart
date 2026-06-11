import 'package:fuelsense/data/datasources/remote/bike/bike_api_service.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/datasources/local/entity/pending_operation_entity.dart';
import '../../operation_handler.dart';

class RemoveBikeHandler implements OperationHandler {
  final BikeApiService _bikeApiService;
  final AppSharedPreferences _prefs;

  RemoveBikeHandler(this._bikeApiService, this._prefs);

  @override
  Future<void> execute(PendingOperationEntity operation) async {
    print(
      '[RemoveBikeHandler] Starting execution for operation ID: ${operation.id}',
    );

    final token = _prefs.getToken();
    if (token == null) {
      print('[RemoveBikeHandler] ERROR: No auth token available');
      throw Exception('No auth token available');
    }
    print('[RemoveBikeHandler] Auth token retrieved');

    final entityId = operation.entityId;
    if (entityId == null) {
      print('[RemoveBikeHandler] ERROR: No entityId in operation');
      throw Exception('entityId is required for removeBike operation');
    }
    print('[RemoveBikeHandler] Entity ID: $entityId');

    print('[RemoveBikeHandler] Calling API removeMyBike...');
    final response = await _bikeApiService.removeMyBike(token, entityId);
    print(
      '[RemoveBikeHandler] API Response - Success: ${response.success}, Message: ${response.message}',
    );
    print('[RemoveBikeHandler] Operation completed successfully');
  }
}
