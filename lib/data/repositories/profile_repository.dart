import 'dart:convert';
import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/datasources/remote/helper.dart';
import 'package:fuelsense/data/datasources/remote/header.dart';
import 'package:fuelsense/data/models/user/user_response.dart';
import 'package:fuelsense/domain/entities/auth/user.dart';
import 'package:fuelsense/domain/repositories/profile_repository.dart'
    as domain_profile;
import 'package:http/http.dart' as http;

class ProfileRepositoryImpl implements domain_profile.ProfileRepository {
  final UserDao userDao;

  ProfileRepositoryImpl(this.userDao);

  @override
  Future<User?> getProfile(String token) async {
    // This would call the API to get profile, but for now we'll just return from local
    // In a real implementation, this might call /auth/me or /user/profile
    final userId = await _getCurrentUserId();
    if (userId == null) return null;
    final userEntity = await userDao.getUserById(userId);
    return userEntity != null ? User.fromEntity(userEntity) : null;
  }

  @override
  Future<void> syncProfile(String token) async {
    try {
      // Assume there's a /auth/me endpoint that returns user profile
      final response = await http.get(
        Uri.parse("$baseUrl/user/profile/"),
        headers: authorizedHeader(token),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final userResponse = UserResponse.fromJson(jsonResponse);

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

  Future<int?> _getCurrentUserId() async {
    // This is a simplified implementation
    // In a real app, you'd get this from preferences or some other way
    final users = await userDao.getAllUsers();
    return users.isNotEmpty ? users.first.localId : null;
  }
}
