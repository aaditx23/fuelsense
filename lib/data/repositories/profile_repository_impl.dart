import 'package:dio/dio.dart';
import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/datasources/remote/dio_client.dart';
import 'package:fuelsense/data/models/user/user_response.dart';
import 'package:fuelsense/domain/entities/auth/user.dart';
import 'package:fuelsense/domain/repositories/profile_repository.dart' as domain_profile;

class ProfileRepositoryImpl implements domain_profile.ProfileRepository {
  final UserDao userDao;
  final Dio _dio;

  ProfileRepositoryImpl(this.userDao, this._dio);

  @override
  Stream<User?> getProfile(String token) async* {
    // Watch all users reactively
    await for (final users in userDao.watchAllUsers()) {
      if (users.isEmpty) {
        yield null;
      } else {
        yield User.fromEntity(users.first);
      }
    }
  }

  @override
  Future<void> syncProfile(String token) async {
    try {
      final response = await _dio.get(
        "/user/profile/",
        options: authOptions(token),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data as Map<String, dynamic>;
        final userData = (jsonResponse['data'] as Map<String, dynamic>?) ?? jsonResponse;
        final userResponse = UserResponse.fromJson(userData);
        
        final userEntity = userResponse.toEntity(''); // Password not needed for sync
        await userDao.upsertUser(userEntity);
      }
    } catch (e) {
      print('Profile sync failed: $e');
    }
  }
}
