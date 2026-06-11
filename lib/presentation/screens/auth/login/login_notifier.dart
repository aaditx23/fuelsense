import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/domain/entities/auth/login_request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/auth/login_usecase.dart';
import 'package:fuelsense/presentation/screens/auth/login/login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  LoginNotifier({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(LoginState(isLoading: false, isSuccess: false, message: null));

  void resetState() {
    state = state.empty();
  }

  Future<void> login(LoginRequest loginRequest) async {
    state = state.copyWith(isLoading: true, message: null, isSuccess: false);
    try {
      final response = await _loginUseCase(loginRequest);
      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
        code: response.code,
      );
      print(response.token);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
      );
    }
  }
}

final loginNotifier = StateNotifierProvider((ref) {
  final LoginUseCase loginUseCase = getIt<LoginUseCase>();
  return LoginNotifier(loginUseCase: loginUseCase);
});
