import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/local/dao/user_dao.dart';
import 'package:fuelsense/data/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/remote/auth/repository/auth_repository.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_state.dart';

class SignupNotifier extends StateNotifier<SignupState> {
  final AuthRepository _authRepository;
  final UserDao _userDao;
  final AppSharedPreferences _prefs;
  SignupNotifier({
    required AuthRepository authRepository,
    required UserDao userDao,
    required AppSharedPreferences prefs,
  }) : _prefs = prefs,
       _userDao = userDao,
       _authRepository = authRepository,
       super(SignupState(isLoading: false, isSuccess: false, message: null));

  void reset() {
    state = state.empty();
  }

  Future<void> signup(SignupRequest signupRequest) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      final response = await _authRepository.signup(signupRequest);
      final userResponse = response.data;
      if (userResponse != null) {
        final user = userResponse.toEntity(signupRequest.password);
        await _userDao.deleteAll();
        final userId = await _userDao.createUser(user);
        _prefs.saveUserId(userId);
        _prefs.saveRole(user.role);
        if (response.token != null) await _prefs.saveToken(response.token!);
      }
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
  final AuthRepository authRepository = getIt();
  final UserDao userDao = getIt();
  final AppSharedPreferences prefs = getIt();
  return SignupNotifier(
    authRepository: authRepository,
    userDao: userDao,
    prefs: prefs,
  );
});
