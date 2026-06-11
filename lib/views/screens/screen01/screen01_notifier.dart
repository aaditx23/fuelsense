import 'package:flutter_riverpod/legacy.dart';
import 'package:template_flutter/di/setup_di.dart';
import 'package:template_flutter/data/local/dao/name_dao.dart';
import 'package:template_flutter/data/local/entity/name_entity.dart';
import 'package:template_flutter/views/screens/screen01/screen01_state.dart';

class Screen01Notifier extends StateNotifier<Screen01State> {
  Screen01Notifier() : super(Screen01State(namesList: []));

  final NameDao nameDao = getIt<NameDao>();

  Future<void> getAllNames() async {
    final names = await nameDao.getNames();
    state = state.copyWith(namesList: names);
  }

  Future<void> insertName(String inputName) async {
    await nameDao.createName(NameEntity(name: inputName));
    await getAllNames();
  }
}

final screen01Provider = StateNotifierProvider((ref) {
  return Screen01Notifier();
});