import 'package:fuelsense/domain/entities/bike/bike.dart';

class PendingBikeState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final List<Bike> pendingBikes;

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
    List<Bike>? pendingBikes,
  }) {
    return PendingBikeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      pendingBikes: pendingBikes ?? this.pendingBikes,
    );
  }
}
