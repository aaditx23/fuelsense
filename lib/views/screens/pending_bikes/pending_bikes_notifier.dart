import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/local/dao/bike_dao.dart';
import 'package:fuelsense/data/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/remote/bike/bike_repository.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/views/screens/pending_bikes/pending_bike_state.dart';

class PendingBikesNotifier extends StateNotifier<PendingBikeState> {
  final BikeRepository bikeRepository;
  final BikeDao bikeDao;
  final AppSharedPreferences prefs;

  PendingBikesNotifier({
    required this.bikeRepository,
    required this.bikeDao,
    required this.prefs,
  }) : super(
         PendingBikeState(isLoading: false, isSuccess: false, pendingBikes: []),
       );

  Future<void> pendingBikes() async {
    final token = prefs.getToken();
    if (token == null) return;
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      message: null,
      pendingBikes: [],
    );
    try {
      final response = await bikeRepository.getPendingBikes(token);
      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
        pendingBikes: response.data,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
        pendingBikes: [],
      );
    }
  }
}

final pendingBikesNotifierProvider =
    StateNotifierProvider<PendingBikesNotifier, PendingBikeState>((ref) {
      final bikeRepository = getIt<BikeRepository>();
      final bikeDao = getIt<BikeDao>();
      final prefs = getIt<AppSharedPreferences>();
      return PendingBikesNotifier(
        bikeRepository: bikeRepository,
        bikeDao: bikeDao,
        prefs: prefs,
      );
    });
