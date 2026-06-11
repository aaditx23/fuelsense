import 'package:fuelsense/domain/repositories/auth_repository.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/data/repositories/auth_repository.dart';
import 'package:fuelsense/data/repositories/bike_repository.dart';
import 'package:fuelsense/data/repositories/preferences_repository_impl.dart';
import 'package:fuelsense/data/repositories/placeholder_repository.dart';
import 'package:fuelsense/domain/usecases/auth/login_usecase.dart';
import 'package:fuelsense/domain/usecases/auth/signup_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/fetch_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/select_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/remove_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/delete_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/get_my_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/get_pending_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/edit_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/approve_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/submit_bike_usecase.dart';
import 'package:fuelsense/domain/usecases/profile/get_profile_usecase.dart';
import 'package:fuelsense/di/setup_di.dart';

void setupRepositories() {
  getIt.registerLazySingleton(() => PlaceholderRepository());

  // Register concrete implementations under their abstraction types
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<BikeRepository>(() => BikeRepositoryImpl());
  getIt.registerLazySingleton<PreferencesRepository>(
    () => PreferencesRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(
    () => LoginUseCase(
      getIt<AuthRepository>(),
      getIt(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignupUseCase(
      getIt<AuthRepository>(),
      getIt(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => FetchBikesUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SelectBikeUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => RemoveBikeUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => DeleteBikeUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetMyBikesUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetPendingBikesUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => EditBikeUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => ApproveBikeUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SubmitBikeUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetProfileUseCase(getIt(), getIt<PreferencesRepository>()),
  );
}
