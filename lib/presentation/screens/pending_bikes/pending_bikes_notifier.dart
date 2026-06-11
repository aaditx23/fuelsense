import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/models/bike/bike_request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/bike/get_pending_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/edit_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/approve_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/delete_bike_usecase.dart';
import 'package:fuelsense/presentation/screens/pending_bikes/pending_bike_state.dart';

class PendingBikesNotifier extends StateNotifier<PendingBikeState> {
  final GetPendingBikesUseCase _getPendingBikesUseCase;
  final EditBikeUseCase _editBikeUseCase;
  final ApproveBikeUseCase _approveBikeUseCase;
  final DeleteBikeUseCase _deleteBikeUseCase;

  PendingBikesNotifier({
    required GetPendingBikesUseCase getPendingBikesUseCase,
    required EditBikeUseCase editBikeUseCase,
    required ApproveBikeUseCase approveBikeUseCase,
    required DeleteBikeUseCase deleteBikeUseCase,
  }) : _getPendingBikesUseCase = getPendingBikesUseCase,
       _editBikeUseCase = editBikeUseCase,
       _approveBikeUseCase = approveBikeUseCase,
       _deleteBikeUseCase = deleteBikeUseCase,
       super(
         PendingBikeState(isLoading: false, isSuccess: false, pendingBikes: []),
       );

  Future<void> pendingBikes() async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      message: null,
      pendingBikes: [],
    );
    try {
      final response = await _getPendingBikesUseCase();
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
    state = state.copyWith(isLoading: true, isSuccess: false, message: null);
    try {
      final response = await _editBikeUseCase(id, bikeRequest);
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
    state = state.copyWith(isLoading: true, isSuccess: false, message: null);
    try {
      final response = await _approveBikeUseCase(id);
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
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _deleteBikeUseCase(bikeId);
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
      final getPendingBikesUseCase = getIt<GetPendingBikesUseCase>();
      final editBikeUseCase = getIt<EditBikeUseCase>();
      final approveBikeUseCase = getIt<ApproveBikeUseCase>();
      final deleteBikeUseCase = getIt<DeleteBikeUseCase>();
      return PendingBikesNotifier(
        getPendingBikesUseCase: getPendingBikesUseCase,
        editBikeUseCase: editBikeUseCase,
        approveBikeUseCase: approveBikeUseCase,
        deleteBikeUseCase: deleteBikeUseCase,
      );
    });
