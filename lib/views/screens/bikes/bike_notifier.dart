import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/remote/bike/bike_repository.dart';
import 'package:fuelsense/di/setup_di.dart';

import '../../../data/local/dao/bike_dao.dart';
import '../../../data/local/shared_preferences/shared_preferences.dart';
import 'bike_state.dart';

class BikeNotifier extends StateNotifier<BikeState> {
  final BikeRepository repository;
  final BikeDao bikeDao;
  final AppSharedPreferences prefs;

  BikeNotifier({
    required this.repository,
    required this.bikeDao,
    required this.prefs,
  }) : super(BikeState());

  bool isAdmin() {
    final role = prefs.getRole();
    if (role != null) {
      return role.toLowerCase().contains("admin");
    }
    return false;
  }

  Future<void> fetchBikes() async {
    final token = prefs.getToken();
    if (token == null) return;
    state = state.copyWith(isLoading: true, message: null);
    try {
      final bikeListResponse = await repository.fetchAllBikes(token);
      final myBikeResponse = await repository.getMyBikes(token);
      state = state.copyWith(
        isLoading: false,
        bikes: bikeListResponse.listData,
        isSuccess: bikeListResponse.success,
        message: bikeListResponse.message,
        myBikes: myBikeResponse.listData?.map((bike) => bike.id).toList(),
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

  Future<void> selectBike(int bikeId) async {
    final token = prefs.getToken();
    if (token == null) return;
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await repository.selectBike(token, bikeId);
      final myBikes = state.myBikes;
      state = state.copyWith(
        isLoading: false,
        bikes: null,
        isSuccess: response.success,
        message: response.message,
        myBikes: (myBikes != null && myBikes.isNotEmpty)
            ? myBikes + [bikeId]
            : [bikeId],
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

  Future<void> removeBike(int bikeId) async {
    final token = prefs.getToken();
    if (token == null) return;
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await repository.removeMyBike(token, bikeId);
      final myBikes = state.myBikes;
      if (myBikes != null) myBikes.remove(bikeId);
      state = state.copyWith(
        isLoading: false,
        bikes: null,
        isSuccess: response.success,
        message: response.message,
        myBikes: myBikes,
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

  Future<void> deleteBike(int bikeId) async {
    final token = prefs.getToken();
    if (token == null) return;
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await repository.deleteBike(token, bikeId);
      final myBikes = state.myBikes;
      if (myBikes != null) myBikes.remove(bikeId);
      state = state.copyWith(
        isLoading: false,
        bikes: state.bikes.where((bike) => bike.id != bikeId).toList(),
        isSuccess: response.success,
        message: response.message,
        myBikes: myBikes,
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

final bikeNotifierProvider = StateNotifierProvider<BikeNotifier, BikeState>((
  ref,
) {
  final bikeRepository = getIt<BikeRepository>();
  final bikeDao = getIt<BikeDao>();
  final prefs = getIt<AppSharedPreferences>();
  return BikeNotifier(
    repository: bikeRepository,
    bikeDao: bikeDao,
    prefs: prefs,
  );
});
