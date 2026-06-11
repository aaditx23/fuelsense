import 'package:fuelsense/data/local/entity/name_entity.dart';

class Screen01State {
  List<NameEntity> namesList = [];

  Screen01State({required this.namesList});

  Screen01State copyWith({List<NameEntity>? namesList}) {
    return Screen01State(namesList: namesList ?? this.namesList);
  }
}
