import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/mappers/auth_mapper.dart';
import 'package:fuelsense/domain/entities/auth/auth_response.dart';
import 'package:fuelsense/domain/entities/auth/signup_request.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository authRepository;
  final UserDao userDao;
  final PreferencesRepository prefs;

  SignupUseCase(this.authRepository, this.userDao, this.prefs);

  Future<AuthResponse> call(SignupRequest signupRequest) async {
    final response = await authRepository.signup(signupRequest);

    final userResponse = response.data;
    if (userResponse != null) {
      final user = userResponse.toEntity(signupRequest.password);
      await userDao.deleteAll();
      final userId = await userDao.createUser(user);
      prefs.saveUserId(userId);
      prefs.saveRole(user.role);
      if (response.token != null) await prefs.saveToken(response.token!);
    }

    return response;
  }
}
