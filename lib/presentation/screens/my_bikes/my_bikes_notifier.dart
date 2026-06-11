import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/bike/get_my_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/remove_bike_usecase.dart';
import 'my_bike_state.dart';

class MyBikeNotifier extends StateNotifier<MyBikeState> {
  final GetMyBikesUseCase _getMyBikesUseCase;
  final RemoveBikeUseCase _removeBikeUseCase;


  MyBikeNotifier({
    required GetMyBikesUseCase getMyBikesUseCase,
    required RemoveBikeUseCase removeBikeUseCase,
  }) : _getMyBikesUseCase = getMyBikesUseCase,
       _removeBikeUseCase = removeBikeUseCase,
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
      return MyBikeNotifier(
        getMyBikesUseCase: getMyBikesUseCase,
        removeBikeUseCase: removeBikeUseCase,
      );
    });
