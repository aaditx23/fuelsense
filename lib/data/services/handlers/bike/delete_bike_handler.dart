import 'package:fuelsense/data/datasources/remote/bike/bike_api_service.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/datasources/local/entity/pending_operation_entity.dart';
import '../../operation_handler.dart';

class DeleteBikeHandler implements OperationHandler {
  final BikeApiService _bikeApiService;
  final AppSharedPreferences _prefs;

  DeleteBikeHandler(this._bikeApiService, this._prefs);

  @override
  Future<void> execute(PendingOperationEntity operation) async {
    print(
      '[DeleteBikeHandler] Starting execution for operation ID: ${operation.id}',
    );

    final token = _prefs.getToken();
    if (token == null) {
      print('[DeleteBikeHandler] ERROR: No auth token available');
      throw Exception('No auth token available');
    }
    print('[DeleteBikeHandler] Auth token retrieved');

    final entityId = operation.entityId;
    if (entityId == null) {
      print('[DeleteBikeHandler] ERROR: No entityId in operation');
      throw Exception('entityId is required for deleteBike operation');
    }
    print('[DeleteBikeHandler] Entity ID: $entityId');

    print('[DeleteBikeHandler] Calling API deleteBike...');
    final response = await _bikeApiService.deleteBike(token, entityId);
    print(
      '[DeleteBikeHandler] API Response - Success: ${response.success}, Message: ${response.message}',
    );

    if (response.success != true) {
      print('[DeleteBikeHandler] ERROR: Server rejected bike deletion');
      throw Exception('Server rejected bike deletion: ${response.message}');
    }
    print('[DeleteBikeHandler] Operation completed successfully');
  }
}
