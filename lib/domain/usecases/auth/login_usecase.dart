import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/domain/entities/auth/auth_response.dart';
import 'package:fuelsense/domain/entities/auth/login_request.dart';
import 'package:fuelsense/domain/repositories/auth_repository.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;
  final UserDao userDao;
  final PreferencesRepository prefs;

  LoginUseCase(this.authRepository, this.userDao, this.prefs);

  Future<AuthResponse> call(LoginRequest loginRequest) async {
    final response = await authRepository.login(loginRequest);

    final userResponse = response.data;
    if (userResponse != null) {
      final user = userResponse.toEntity(loginRequest.password);

      await userDao.deleteAll();
      final userId = await userDao.createUser(user);
      prefs.saveUserId(user.remoteId);
      prefs.saveRole(user.role);
      if (response.token != null) await prefs.saveToken(response.token!);
      print("USER ID: $userId");
      print("USER: ${response.token}");
    }

    return response;
  }
}
