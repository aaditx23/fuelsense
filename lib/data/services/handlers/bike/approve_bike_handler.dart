import 'package:fuelsense/data/datasources/remote/bike/bike_api_service.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/datasources/local/entity/pending_operation_entity.dart';
import '../../operation_handler.dart';

class ApproveBikeHandler implements OperationHandler {
  final BikeApiService _bikeApiService;
  final AppSharedPreferences _prefs;

  ApproveBikeHandler(this._bikeApiService, this._prefs);

  @override
  Future<void> execute(PendingOperationEntity operation) async {
    print(
      '[ApproveBikeHandler] Starting execution for operation ID: ${operation.id}',
    );

    final token = _prefs.getToken();
    if (token == null) {
      print('[ApproveBikeHandler] ERROR: No auth token available');
      throw Exception('No auth token available');
    }
    print('[ApproveBikeHandler] Auth token retrieved');

    final entityId = operation.entityId;
    if (entityId == null) {
      print('[ApproveBikeHandler] ERROR: No entityId in operation');
      throw Exception('entityId is required for approveBike operation');
    }
    print('[ApproveBikeHandler] Entity ID: $entityId');

    print('[ApproveBikeHandler] Calling API approveBike...');
    final response = await _bikeApiService.approveBike(token, entityId);
    print(
      '[ApproveBikeHandler] API Response - Success: ${response.success}, Message: ${response.message}',
    );
    print(
      '[ApproveBikeHandler] API Response - Data: ${response.data?.toJson().toString()}',
    );
    print('[ApproveBikeHandler] Operation completed successfully');
  }
}
