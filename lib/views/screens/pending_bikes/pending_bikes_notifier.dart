import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/local/dao/bike_dao.dart';
import 'package:fuelsense/data/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/remote/bike/bike_repository.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_request.dart';
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
        pendingBikes: response.listData,
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

  Future<void> editBike(int id, BikeRequest bikeRequest) async {
    final token = prefs.getToken();
    if (token == null) return;
    state = state.copyWith(isLoading: true, isSuccess: false, message: null);
    try {
      final response = await bikeRepository.editBike(token, bikeRequest, id);
      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

  Future<void> approveBike(int id) async {
    final token = prefs.getToken();
    if (token == null) return;
    state = state.copyWith(isLoading: true, isSuccess: false, message: null);
    try {
      final response = await bikeRepository.approveBike(token, id);
      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
        pendingBikes: state.pendingBikes
            .where((bike) => bike.id != id)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

  Future<void> deleteBike(int bikeId) async {
    final token = prefs.getToken();
    if (token == null) return;
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await bikeRepository.deleteBike(token, bikeId);
      state = state.copyWith(
        isLoading: false,
        pendingBikes: state.pendingBikes
            .where((bike) => bike.id != bikeId)
            .toList(),
        isSuccess: response.success,
        message: response.message,
      );
    } catch (e) {
      print(e.toString());
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
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
