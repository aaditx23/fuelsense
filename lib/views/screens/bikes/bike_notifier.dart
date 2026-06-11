import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/remote/bike/bike_repository.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_response.dart';
import 'package:fuelsense/di/setup_di.dart';


import '../../../data/local/dao/bike_dao.dart';
import '../../../data/local/shared_preferences/shared_preferences.dart';
import 'bike_state.dart';

class BikeNotifier extends StateNotifier<BikeState> {
  final BikeRepository repository;
  final BikeDao bikeDao;
  final AppSharedPreferences prefs;

  BikeNotifier({required this.repository, required this.bikeDao, required this.prefs}) : super(BikeState());

  Future<void> fetchBikes() async {
    final token = prefs.getToken();
    state = state.copyWith(isLoading: true, message: null);
    try {
      final BikeResponse response = await repository.fetchAllBikes(token ?? "");
      print("Respoesns: ${response.success} ${response.message}");
      state = state.copyWith(isLoading: false, bikes: response.data, isSuccess: response.success, message: response.message);
    } catch (e) {
      print(e.toString());
      state = state.copyWith(isLoading: false, isSuccess: false, message: e.toString());
    }
  }
}

final bikeNotifierProvider = StateNotifierProvider<BikeNotifier, BikeState>((ref) {
  final bikeRepository = getIt<BikeRepository>();
  final bikeDao = getIt<BikeDao>();
  final prefs = getIt<AppSharedPreferences>();
  return BikeNotifier(repository: bikeRepository, bikeDao: bikeDao, prefs: prefs);
});
