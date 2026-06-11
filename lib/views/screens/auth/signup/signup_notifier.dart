import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/remote/auth/repository/auth_repository.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_state.dart';

import 'package:fuelsense/data/local/dao/user_dao.dart';

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(SignupState(isLoading: false, isSuccess: false));

  final AuthRepository _authRepository = getIt<AuthRepository>();
  final UserDao _userDao = getIt<UserDao>();

  Future<void> signup(SignupRequest signupRequest) async {
    state = state.copyWith(isLoading: true, message: null);
    final response = await _authRepository.signup(signupRequest);
    state = state.copyWith(
      isLoading: false,
      isSuccess: response.success,
      message: response.message,
      code: response.code,
    );
    final userResponse = response.data;
    if(userResponse != null){
      final user = userResponse.toEntity(signupRequest.password);
      await _userDao.createUser(user);
    }
  }
}

final signupNotifier = StateNotifierProvider((ref) {
  return SignupNotifier();
});

