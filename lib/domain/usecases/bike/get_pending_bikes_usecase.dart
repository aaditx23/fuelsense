import 'package:fuelsense/data/models/bike/bike_response.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class GetPendingBikesUseCase {
  final BikeRepository repository;
  final AppSharedPreferences prefs;

  GetPendingBikesUseCase(this.repository, this.prefs);

  Future<BikeResponse> call() async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.getPendingBikes(token);
  }
}