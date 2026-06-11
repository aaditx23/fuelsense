import 'package:flutter_template/data/repository/placeholder_repository.dart';
import 'package:flutter_template/di/setup_di.dart';

void setupRepositories() {
  getIt.registerLazySingleton<PlaceholderRepository>(
    () => PlaceholderRepository(),
  );
}
