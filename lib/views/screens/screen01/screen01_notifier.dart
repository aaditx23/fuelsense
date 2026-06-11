
import 'package:flutter_riverpod/legacy.dart';
import 'package:template_flutter/di/setup_di.dart';
import 'package:template_flutter/data/local/dao/name_dao.dart';
import 'package:template_flutter/data/local/entity/name_entity.dart';


class Screen01Notifier extends StateNotifier<List<NameEntity>> {

  Screen01Notifier(): super([]);

  final NameDao nameDao = getIt<NameDao>();

  Future<void> getAllNames() async {
    state = await nameDao.getNames();
  }

  Future<void> insertName(String inputName) async {
    await nameDao.createName(
      NameEntity(name: inputName)
    );
    await getAllNames();
  }

}

final screen01Provider = StateNotifierProvider((ref) {
  return Screen01Notifier();
});