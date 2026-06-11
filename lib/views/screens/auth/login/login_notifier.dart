import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/local/dao/user_dao.dart';
import 'package:fuelsense/data/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/remote/auth/repository/auth_repository.dart';
import 'package:fuelsense/data/remote/auth/schema/request.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/views/screens/auth/login/login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final UserDao _userDao;
  final AppSharedPreferences prefs;
  LoginNotifier({
    required AuthRepository authRepository,
    required UserDao userDao,
    required this.prefs,
  }) : _userDao = userDao,
       _authRepository = authRepository,
       super(LoginState(isLoading: false, isSuccess: false, message: null));

  void resetState() {
    state = state.empty();
  }

  Future<void> login(LoginRequest loginRequest) async {
    state = state.copyWith(isLoading: true, message: null, isSuccess: false);
    try {
      final response = await _authRepository.login(loginRequest);

      final userResponse = response.data;
      if (userResponse != null) {
        final user = userResponse.toEntity(loginRequest.password);

        final userId = await _userDao.createUser(user);
        prefs.saveUserId(userId);
        prefs.saveRole(user.role);
        if (response.token != null) await prefs.saveToken(response.token!);
      }
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
  final AuthRepository authRepository = getIt<AuthRepository>();
  final UserDao userDao = getIt<UserDao>();
  final AppSharedPreferences prefs = getIt<AppSharedPreferences>();
  return LoginNotifier(
    authRepository: authRepository,
    userDao: userDao,
    prefs: prefs,
  );
});
