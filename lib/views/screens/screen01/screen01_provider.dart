import 'package:flutter/cupertino.dart';
import 'package:template_flutter/di/setup_di.dart';
import 'package:template_flutter/data/local/dao/name_dao.dart';
import 'package:template_flutter/data/local/entity/name_entity.dart';

class Screen01Provider with ChangeNotifier {
  final NameDao nameDao = getIt<NameDao>();

  List<NameEntity> _namesList = [];
  List<NameEntity> get namesList => _namesList;

  Future<void> getAllNames() async {
    _namesList = await nameDao.getNames();
    notifyListeners();
  }

  Future<void> insertName(String inputName) async {
    await nameDao.createName(NameEntity(name: inputName));
    await getAllNames();
    notifyListeners();
  }
}
