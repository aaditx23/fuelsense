import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/remote/auth/repository/auth_repository.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_state.dart';

import 'package:fuelsense/data/local/dao/user_dao.dart';

class SignupNotifier extends StateNotifier<SignupState> {
  final AuthRepository authRepository;
  final UserDao userDao;
  final AppSharedPreferences prefs;
  SignupNotifier({
    required this.authRepository,
    required this.userDao,
    required this.prefs
  }) : super(SignupState(isLoading: false, isSuccess: false));

  Future<void> signup(SignupRequest signupRequest) async {
    state = state.copyWith(isLoading: true, message: null);
    final response = await authRepository.signup(signupRequest);
    final userResponse = response.data;
    if(userResponse != null){
      final user = userResponse.toEntity(signupRequest.password);
      await prefs.saveUserId(user.id);
      if(response.access_token != null) await prefs.saveToken(response.access_token!);
      await userDao.createUser(user);
    }
    state = state.copyWith(
      isLoading: false,
      isSuccess: response.success,
      message: response.message,
      code: response.code,
    );
  }
}

final signupNotifier = StateNotifierProvider((ref) {
  final AuthRepository authRepository = getIt();
  final UserDao userDao = getIt();
  final AppSharedPreferences prefs = getIt();
  return SignupNotifier(
    authRepository: authRepository,
    userDao: userDao,
    prefs: prefs
  );
});

