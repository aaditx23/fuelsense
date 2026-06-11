import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/domain/entities/auth/signup_request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/auth/signup_usecase.dart';
import 'package:fuelsense/presentation/screens/auth/signup/signup_state.dart';

class SignupNotifier extends StateNotifier<SignupState> {
  final SignupUseCase _signupUseCase;
  SignupNotifier({required SignupUseCase signupUseCase})
    : _signupUseCase = signupUseCase,
      super(SignupState(isLoading: false, isSuccess: false, message: null));

  void reset() {
    state = state.empty();
  }

  Future<void> signup(SignupRequest signupRequest) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _signupUseCase(signupRequest);
      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
        code: response.code,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString(),
      );
    }
  }
}

final signupNotifierProvider = StateNotifierProvider((ref) {
  final SignupUseCase signupUseCase = getIt();
  return SignupNotifier(signupUseCase: signupUseCase);
});
