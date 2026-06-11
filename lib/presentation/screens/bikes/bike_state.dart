import 'package:fuelsense/domain/entities/bike/bike.dart';

class BikeState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final List<Bike> bikes;

  BikeState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.bikes = const [],
  });

  BikeState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    List<Bike>? bikes,
  }) {
    return BikeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message,
      bikes: bikes ?? this.bikes,
    );
  }
}
