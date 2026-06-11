import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/profile/get_profile_usecase.dart';
import 'package:fuelsense/presentation/screens/profile/profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;

  ProfileNotifier({required GetProfileUseCase getProfileUseCase})
    : _getProfileUseCase = getProfileUseCase,
      super(ProfileState(isLoading: true)) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, message: null, user: null);
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
      return ProfileNotifier(getProfileUseCase: getProfileUseCase);
    });
