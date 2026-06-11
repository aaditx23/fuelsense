import 'package:fuelsense/domain/entities/bike/bike.dart';

class MyBikeState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final List<Bike> myBikes;

  MyBikeState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.myBikes = const [],
  });

  MyBikeState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    List<Bike>? myBikes,
  }) {
    return MyBikeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message,
      myBikes: myBikes ?? this.myBikes,
    );
  }
}
