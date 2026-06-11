import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/datasources/local/entity/user_entity.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/entities/auth/user.dart';

class GetProfileUseCase {
  final UserDao userDao;
  final PreferencesRepository prefs;

  GetProfileUseCase(this.userDao, this.prefs);

  Future<User?> call() async {
    final userId = prefs.getUserId();
    if (userId == null) return null;
    final userEntity = await userDao.getUserById(userId);
    return userEntity != null ? User.fromEntity(userEntity) : null;
  }
}
