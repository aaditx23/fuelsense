import 'package:fuelsense/data/datasources/remote/bike/bike_api_service.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/datasources/local/entity/pending_operation_entity.dart';
import '../../operation_handler.dart';

class SelectBikeHandler implements OperationHandler {
  final BikeApiService _bikeApiService;
  final AppSharedPreferences _prefs;

  SelectBikeHandler(this._bikeApiService, this._prefs);

  @override
  Future<void> execute(PendingOperationEntity operation) async {
    print(
      '[SelectBikeHandler] Starting execution for operation ID: ${operation.id}',
    );

    final token = _prefs.getToken();
    if (token == null) {
      print('[SelectBikeHandler] ERROR: No auth token available');
      throw Exception('No auth token available');
    }
    print('[SelectBikeHandler] Auth token retrieved');

    final entityId = operation.entityId;
    if (entityId == null) {
      print('[SelectBikeHandler] ERROR: No entityId in operation');
      throw Exception('entityId is required for selectBike operation');
    }
    print('[SelectBikeHandler] Entity ID: $entityId');

    print('[SelectBikeHandler] Calling API selectBike...');
    final response = await _bikeApiService.selectBike(token, entityId);
    print(
      '[SelectBikeHandler] API Response - Success: ${response.success}, Message: ${response.message}',
    );
    print('[SelectBikeHandler] Operation completed successfully');
  }
}
