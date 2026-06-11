import 'package:fuelsense/domain/entities/bike/bike.dart';

class AddBikeState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final Bike? bike;

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
    Bike? bike,
  }) {
    return AddBikeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      bike: bike ?? this.bike,
    );
  }
}
