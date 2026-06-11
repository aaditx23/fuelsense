import 'package:fuelsense/data/remote/bike/schema/bike_model.dart';

class PendingBikeState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final List<BikeModel> pendingBikes;

  PendingBikeState({
    required this.isLoading,
    required this.isSuccess,
    this.message,
    this.pendingBikes = const [],
  });

  PendingBikeState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    List<BikeModel>? pendingBikes,
  }) {
    return PendingBikeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      pendingBikes: pendingBikes ?? this.pendingBikes,
    );
  }
}
