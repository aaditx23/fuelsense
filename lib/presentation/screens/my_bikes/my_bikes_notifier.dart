import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/bike/get_my_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/remove_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/sync_my_bikes_usecase.dart';
import 'my_bike_state.dart';

class MyBikeNotifier extends StateNotifier<MyBikeState> {
  final GetMyBikesUseCase _getMyBikesUseCase;
  final RemoveBikeUseCase _removeBikeUseCase;
  final SyncMyBikesUseCase _syncMyBikesUseCase;

  MyBikeNotifier({
    required GetMyBikesUseCase getMyBikesUseCase,
    required RemoveBikeUseCase removeBikeUseCase,
    required SyncMyBikesUseCase syncMyBikesUseCase,
  }) : _getMyBikesUseCase = getMyBikesUseCase,
       _removeBikeUseCase = removeBikeUseCase,
       _syncMyBikesUseCase = syncMyBikesUseCase,
       super(MyBikeState());

  Future<void> getMyBikes() async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _getMyBikesUseCase();
      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
        myBikes: response.listData,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
      );
    }
  }

  Future<void> syncMyBikes() async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _syncMyBikesUseCase();
      // After syncing, fetch the updated data
      await getMyBikes();
    } catch (e) {
      print(e.toString());
      // If sync fails, still try to load from local storage
      await getMyBikes();
    }
  }

  Future<void> removeBike(int bikeId) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _removeBikeUseCase(bikeId);
      final myBikes = state.myBikes;
      myBikes.removeWhere((bike) => bike.id == bikeId);
      state = state.copyWith(
        isLoading: false,
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

final myBikesNotifierProvider =
    StateNotifierProvider<MyBikeNotifier, MyBikeState>((ref) {
      final getMyBikesUseCase = getIt<GetMyBikesUseCase>();
      final removeBikeUseCase = getIt<RemoveBikeUseCase>();
      final syncMyBikesUseCase = getIt<SyncMyBikesUseCase>();
      return MyBikeNotifier(
        getMyBikesUseCase: getMyBikesUseCase,
        removeBikeUseCase: removeBikeUseCase,
        syncMyBikesUseCase: syncMyBikesUseCase,
      );
    });
