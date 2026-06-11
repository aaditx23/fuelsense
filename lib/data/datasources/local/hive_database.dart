import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  await Hive.openBox('users');
  await Hive.openBox('bikes');
  await Hive.openBox('fuel_records');
  await Hive.openBox('reserve_cycles');
  await Hive.openBox('pending_operations');
}
