import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/remote/bike/bike_repository.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_response.dart';
import 'package:fuelsense/di/setup_di.dart';


import '../../../data/local/dao/bike_dao.dart';
import '../../../data/local/shared_preferences/shared_preferences.dart';
import 'my_bike_state.dart';

class MyBikeNotifier extends StateNotifier<MyBikeState> {
  final BikeRepository repository;
  final BikeDao bikeDao;
  final AppSharedPreferences prefs;

  MyBikeNotifier({required this.repository, required this.bikeDao, required this.prefs}) : super(MyBikeState());

  Future<void> getMyBikes() async {
    final token = prefs.getToken();
    if(token == null) return;
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await repository.getMyBikes(token);
      state = state.copyWith(
          isLoading: false,
          isSuccess: response.success,
          message: response.message,
          myBikes: response.data
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isSuccess: false, message: e.toString());
    }
  }

  Future<void> removeBike(int bikeId) async{
    final token = prefs.getToken();
    if (token == null) return ;
    state = state.copyWith(isLoading: true, message: null);
    try{
      final response = await repository.removeMyBike(token, bikeId);
      final myBikes = state.myBikes;
      myBikes.removeWhere((bike) => bike.id ==bikeId);
      state = state.copyWith(
          isLoading: false,
          isSuccess: response.success,
          message: response.message,
          myBikes: myBikes
      );
    }
    catch (e){
      print(e.toString());
      state = state.copyWith(isLoading: false, isSuccess: false, message: e.toString());
    }
  }
}

final myBikesNotifierProvider = StateNotifierProvider<MyBikeNotifier, MyBikeState>((ref) {
  final bikeRepository = getIt<BikeRepository>();
  final bikeDao = getIt<BikeDao>();
  final prefs = getIt<AppSharedPreferences>();
  return MyBikeNotifier(repository: bikeRepository, bikeDao: bikeDao, prefs: prefs);
});
