import 'dart:convert';

import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/datasources/remote/header.dart';
import 'package:fuelsense/data/datasources/remote/helper.dart';
import 'package:fuelsense/data/models/user/user_response.dart';
import 'package:fuelsense/domain/entities/auth/user.dart';
import 'package:fuelsense/domain/repositories/profile_repository.dart'
    as domain_profile;
import 'package:http/http.dart' as http;

class ProfileRepositoryImpl implements domain_profile.ProfileRepository {
  final UserDao userDao;

  ProfileRepositoryImpl(this.userDao);

  @override
  Stream<User?> getProfile(String token) async* {
    // Watch all users reactively — unaffected by localId changes from upsertUser
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
      final response = await http.get(
        Uri.parse("$baseUrl/user/profile/"),
        headers: authorizedHeader(token),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        // API returns envelope: { success, message, data: { id, ... } }
        final userData =
            (jsonResponse['data'] as Map<String, dynamic>?) ?? jsonResponse;
        final userResponse = UserResponse.fromJson(userData);
        print("USerData: ${userResponse.id}");

        // Upsert the user data
        final userEntity = userResponse.toEntity(
          '',
        ); // Password not needed for sync
        await userDao.upsertUser(userEntity);
      }
    } catch (e) {
      // If sync fails, just continue - we still have local data
      print('Profile sync failed: $e');
    }
  }
}
