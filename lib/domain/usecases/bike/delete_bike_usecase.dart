import 'package:fuelsense/data/models/base_response.dart';
import 'package:fuelsense/domain/entities/bike/add_bike_response.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class DeleteBikeUseCase {
  final BikeRepository repository;
  final PreferencesRepository prefs;

  DeleteBikeUseCase(this.repository, this.prefs);

  Future<BaseResponse> call(int bikeId) async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    return await repository.deleteBike(token, bikeId);
  }
}
