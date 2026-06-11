import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/profile/get_profile_usecase.dart';
import 'package:fuelsense/domain/usecases/profile/sync_profile_usecase.dart';
import 'package:fuelsense/presentation/screens/profile/profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final SyncProfileUseCase _syncProfileUseCase;

  ProfileNotifier({
    required GetProfileUseCase getProfileUseCase,
    required SyncProfileUseCase syncProfileUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _syncProfileUseCase = syncProfileUseCase,
       super(ProfileState(isLoading: false));

  Future<void> syncProfile() async {
    state = state.copyWith(isLoading: true, message: null, user: null);
    try {
      await _syncProfileUseCase();
      // After syncing, load the profile
      await loadProfile();
    } catch (e) {
      // If sync fails, still try to load from local storage
      await loadProfile();
    }
  }

  Future<void> loadProfile() async {
    final user = await _getProfileUseCase();
    if (user == null) {
      state = state.copyWith(isLoading: false, message: 'User not found');
      return;
    }
    state = state.copyWith(isLoading: false, user: user);
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      final getProfileUseCase = getIt<GetProfileUseCase>();
      final syncProfileUseCase = getIt<SyncProfileUseCase>();
      return ProfileNotifier(
        getProfileUseCase: getProfileUseCase,
        syncProfileUseCase: syncProfileUseCase,
      );
    });
