

import 'package:fuelsense/data/models/bike/bike_model.dart';

class MyBikeState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final List<BikeModel> myBikes;


  MyBikeState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.myBikes = const []
  });

  MyBikeState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    List<BikeModel>? myBikes,
  }) {
    return MyBikeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message,
      myBikes: myBikes ?? this.myBikes
    );
  }
}