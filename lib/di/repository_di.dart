import 'package:fuelsense/data/remote/auth/repository/auth_repository.dart';
import 'package:fuelsense/data/repository/placeholder_repository.dart';
import 'package:fuelsense/di/setup_di.dart';

void setupRepositories() {
  getIt.registerLazySingleton(() => PlaceholderRepository());

  getIt.registerLazySingleton(() => AuthRepository());
}
