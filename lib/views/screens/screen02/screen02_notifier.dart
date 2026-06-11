import 'package:flutter_riverpod/legacy.dart';
import 'package:template_flutter/data/repository/placeholder_repository.dart';
import 'package:template_flutter/di/setup_di.dart';
import 'package:template_flutter/views/screens/screen02/screen02_state.dart';

class Screen02Notifier extends StateNotifier<Screen02State> {
  Screen02Notifier() : super(Screen02State(isLoading: false));

  final PlaceholderRepository pr = getIt<PlaceholderRepository>();

  Future<void> getTodo(int id) async {
    state = state.copyWith(isLoading: true);
    final todo = await pr.getTodo(id);
    state = state.copyWith(todo: todo, isLoading: true);
  }
}

final screen02Provider = StateNotifierProvider((ref) {
  return Screen02Notifier();
});
