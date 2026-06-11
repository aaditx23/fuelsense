import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/datasources/local/entity/user_entity.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';

class GetProfileUseCase {
  final UserDao userDao;
  final AppSharedPreferences prefs;

  GetProfileUseCase(this.userDao, this.prefs);

  Future<UserEntity?> call() async {
    final userId = prefs.getUserId();
    if (userId == null) return null;
    return await userDao.getUserById(userId);
  }
}