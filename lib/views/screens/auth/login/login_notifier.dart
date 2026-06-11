import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/local/dao/user_dao.dart';
import 'package:fuelsense/data/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/remote/auth/repository/auth_repository.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/views/screens/auth/login/login_state.dart';
import 'package:http/http.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState(isLoading: false, isSuccess: false));

  final AuthRepository _authRepository = getIt<AuthRepository>();
  final UserDao _userDao = getIt<UserDao>();
  final AppSharedPreferences prefs = getIt<AppSharedPreferences>();

  Future<void> login(LoginRequest loginRequest) async {
    state = state.copyWith(isLoading: true, message: null);
    final response = await _authRepository.login(loginRequest);
    state = state.copyWith(
      isLoading: false,
      isSuccess: response.success,
      message: response.message,
      code: response.code,
    );

    final userResponse = response.data;
    if(userResponse != null){
      final user = userResponse.toEntity(loginRequest.password);
      await prefs.saveUserId(user.id);
      await _userDao.createUser(user);

    }
  }
}

final loginNotifier = StateNotifierProvider((ref) {
  return LoginNotifier();
});
