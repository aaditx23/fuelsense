import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/data/local/dao/user_dao.dart';
import 'package:fuelsense/data/local/entity/user_entity.dart';
import 'package:fuelsense/data/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/views/screens/profile/profile_state.dart';
import 'package:fuelsense/di/setup_di.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final UserDao _userDao;
  final AppSharedPreferences _prefs;

  ProfileNotifier({required UserDao userDao, required AppSharedPreferences prefs}) : _prefs = prefs, _userDao = userDao, super(ProfileState(isLoading: true)) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, message: null, user: null);
    final userId = _prefs.getUserId();
    print("USR ID: $userId");
    print(_prefs.getToken());
    if (userId == null) {
      state = state.copyWith(isLoading: false, message: 'User not logged in');
      return;
    }
    final user = await _userDao.getUserById(userId);
    if (user == null) {
      state = state.copyWith(isLoading: false, message: 'User not found');
      return;
    }
    state = state.copyWith(isLoading: false, user: user);
  }
}

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final userDao = getIt<UserDao>();
  final prefs = getIt<AppSharedPreferences>();
  return ProfileNotifier(userDao: userDao, prefs: prefs);
});
