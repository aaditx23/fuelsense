

import 'package:fuelsense/data/models/bike/bike_model.dart';

class BikeState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final List<BikeModel> bikes;
  final List<int>? myBikes;

  BikeState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.bikes = const [],
    this.myBikes = const []
  });

  BikeState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    List<BikeModel>? bikes,
    List<int>? myBikes
  }) {
    return BikeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message,
      bikes: bikes ?? this.bikes,
      myBikes: myBikes ?? this.myBikes
    );
  }
}