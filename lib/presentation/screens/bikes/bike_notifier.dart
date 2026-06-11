import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/bike/fetch_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/select_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/remove_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/delete_bike_usecase.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'bike_state.dart';

class BikeNotifier extends StateNotifier<BikeState> {
  final FetchBikesUseCase _fetchBikesUseCase;
  final SelectBikeUseCase _selectBikeUseCase;
  final RemoveBikeUseCase _removeBikeUseCase;
  final DeleteBikeUseCase _deleteBikeUseCase;
  final AppSharedPreferences prefs;

  BikeNotifier({
    required FetchBikesUseCase fetchBikesUseCase,
    required SelectBikeUseCase selectBikeUseCase,
    required RemoveBikeUseCase removeBikeUseCase,
    required DeleteBikeUseCase deleteBikeUseCase,
    required this.prefs,
  }) : _fetchBikesUseCase = fetchBikesUseCase,
       _selectBikeUseCase = selectBikeUseCase,
       _removeBikeUseCase = removeBikeUseCase,
       _deleteBikeUseCase = deleteBikeUseCase,
       super(BikeState());

  bool isAdmin() {
    final role = prefs.getRole();
    if (role != null) {
      return role.toLowerCase().contains("admin");
    }
    return false;
  }

  Future<void> fetchBikes() async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final result = await _fetchBikesUseCase();
      state = state.copyWith(
        isLoading: false,
        bikes: result['bikes'],
        isSuccess: result['isSuccess'],
        message: result['message'],
        myBikes: result['myBikes'],
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
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _selectBikeUseCase(bikeId);
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
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _removeBikeUseCase(bikeId);
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
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _deleteBikeUseCase(bikeId);
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
  final fetchBikesUseCase = getIt<FetchBikesUseCase>();
  final selectBikeUseCase = getIt<SelectBikeUseCase>();
  final removeBikeUseCase = getIt<RemoveBikeUseCase>();
  final deleteBikeUseCase = getIt<DeleteBikeUseCase>();
  final prefs = getIt<AppSharedPreferences>();
  return BikeNotifier(
    fetchBikesUseCase: fetchBikesUseCase,
    selectBikeUseCase: selectBikeUseCase,
    removeBikeUseCase: removeBikeUseCase,
    deleteBikeUseCase: deleteBikeUseCase,
    prefs: prefs,
  );
});
