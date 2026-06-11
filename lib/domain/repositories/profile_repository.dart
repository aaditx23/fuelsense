import 'package:fuelsense/domain/entities/auth/user.dart';

abstract class ProfileRepository {
  Future<User?> getProfile(String token);
  Future<void> syncProfile(String token);
}
