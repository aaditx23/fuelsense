import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/remote/auth/repository/auth_repository.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_state.dart';

class SignupNotifier extends StateNotifier<SignupState> {
  SignupNotifier() : super(SignupState(isLoading: false, isSuccess: false));

  final AuthRepository _authRepository = getIt<AuthRepository>();

  Future<void> signup(SignupRequest signupRequest) async {
    state = state.copyWith(isLoading: true, message: null);
    final response = await _authRepository.signup(signupRequest);
    state = state.copyWith(
      isLoading: false,
      isSuccess: response.success,
      message: response.message,
      code: response.code,
    );
    // save response.data to localstorage if needed
  }
}

final signupNotifier = StateNotifierProvider((ref) {
  return SignupNotifier();
});

