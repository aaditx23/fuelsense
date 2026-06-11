import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/remote/auth/repository/auth_repository.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/views/screens/auth/login/login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState(isLoading: false, isSuccess: false));

  final AuthRepository _authRepository = getIt<AuthRepository>();

  Future<void> login(LoginRequest loginRequest) async {
    state = state.copyWith(isLoading: true, message: null);
    final response = await _authRepository.login(loginRequest);
    state = state.copyWith(
      isLoading: false,
      isSuccess: response.success,
      message: response.message,
      code: response.code,
    );

    // save response.data to localstorage
  }
}

final loginNotifier = StateNotifierProvider((ref) {
  return LoginNotifier();
});
