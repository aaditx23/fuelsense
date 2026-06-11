import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';

class FetchBikesUseCase {
  final BikeRepository repository;
  final PreferencesRepository prefs;

  FetchBikesUseCase(this.repository, this.prefs);

  Future<Map<String, dynamic>> call() async {
    final token = prefs.getToken();
    if (token == null) throw Exception('No token');

    final bikeListResponse = await repository.fetchAllBikes(token);
    final myBikeResponse = await repository.getMyBikes(token);

    return {
      'bikes': bikeListResponse.listData,
      'isSuccess': bikeListResponse.success,
      'message': bikeListResponse.message,
      'myBikes': myBikeResponse.listData?.map((bike) => bike.id).toList(),
    };
  }
}
