import 'package:template_flutter/data/repository/placeholder_repository.dart';
import 'package:template_flutter/di/setup_di.dart';

void setupRepositories() {
  getIt.registerLazySingleton<PlaceholderRepository>(
    () => PlaceholderRepository(),
  );
}
