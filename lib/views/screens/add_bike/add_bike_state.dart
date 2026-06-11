import 'package:fuelsense/data/remote/bike/schema/bike_model.dart';

class AddBikeState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final BikeModel? bike;

  AddBikeState({
    required this.isLoading,
    required this.isSuccess,
    this.message,
    this.bike,
  });

  AddBikeState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    BikeModel? bike,
  }) {
    return AddBikeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      bike: bike ?? this.bike,
    );
  }
}
