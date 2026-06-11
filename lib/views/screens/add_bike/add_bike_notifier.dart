import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/local/dao/bike_dao.dart';
import 'package:fuelsense/data/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/remote/bike/bike_repository.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/views/screens/add_bike/add_bike_state.dart';

class AddBikeNotifier extends StateNotifier<AddBikeState> {
  final BikeRepository _bikeRepository;
  final BikeDao _bikeDao;
  final AppSharedPreferences _prefs;

  AddBikeNotifier({
    required BikeRepository bikeRepository,
    required BikeDao bikeDao,
    required AppSharedPreferences prefs,
  }) : _prefs = prefs,
       _bikeDao = bikeDao,
       _bikeRepository = bikeRepository,
       super(AddBikeState(isLoading: false, isSuccess: false, message: null));

  Future<void> submitBike(BikeRequest bikeRequest) async {
    final token = _prefs.getToken();
    if (token == null) return;
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _bikeRepository.submitBike(token, bikeRequest);
      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
      );
      print(response);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
        bike: null,
      );
    }
  }
}

final addBikeNotifierProvider =
    StateNotifierProvider<AddBikeNotifier, AddBikeState>((ref) {
      final bikeRepository = getIt<BikeRepository>();
      final bikeDao = getIt<BikeDao>();
      final prefs = getIt<AppSharedPreferences>();
      return AddBikeNotifier(
        bikeRepository: bikeRepository,
        bikeDao: bikeDao,
        prefs: prefs,
      );
    });
