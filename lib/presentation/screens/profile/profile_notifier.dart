import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/usecases/profile/get_profile_usecase.dart';
import 'package:fuelsense/domain/usecases/profile/sync_profile_usecase.dart';
import 'package:fuelsense/presentation/screens/profile/profile_state.dart';

class ProfileNotifier extends StreamNotifier<ProfileState> {
  @override
  Stream<ProfileState> build() async* {
    final getProfileUseCase = ref.watch(getProfileUseCaseProvider);
    final syncProfileUseCase = ref.watch(syncProfileUseCaseProvider);

    // Emit initial loading state
    yield ProfileState(isLoading: true);

    // Start sync in background
    unawaited(
      syncProfileUseCase().catchError((e) {
        // Handle sync error if needed
      }),
    );

    // Listen to the user stream and yield states

    await for (final user in getProfileUseCase()) {
      if (user == null) {
        yield ProfileState(isLoading: false, message: 'User not found');
      } else {
        yield ProfileState(isLoading: false, user: user);
      }
    }
  }
}

final getProfileUseCaseProvider = Provider<GetProfileUseCase>(
  (ref) => getIt<GetProfileUseCase>(),
);

final syncProfileUseCaseProvider = Provider<SyncProfileUseCase>(
  (ref) => getIt<SyncProfileUseCase>(),
);

final profileNotifierProvider =
    StreamNotifierProvider<ProfileNotifier, ProfileState>(
      () => ProfileNotifier(),
    );
