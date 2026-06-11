import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/bike/submit_bike_usecase.dart';
import 'package:fuelsense/presentation/screens/add_bike/add_bike_state.dart';

class AddBikeNotifier extends StateNotifier<AddBikeState> {
  final SubmitBikeUseCase _submitBikeUseCase;

  AddBikeNotifier({required SubmitBikeUseCase submitBikeUseCase})
    : _submitBikeUseCase = submitBikeUseCase,
      super(AddBikeState(isLoading: false, isSuccess: false, message: null));

  Future<void> submitBike(BikeRequest bikeRequest) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _submitBikeUseCase(bikeRequest);
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
      final submitBikeUseCase = getIt<SubmitBikeUseCase>();
      return AddBikeNotifier(submitBikeUseCase: submitBikeUseCase);
    });
