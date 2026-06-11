import 'package:dio/dio.dart';
import 'package:fuelsense/data/datasources/remote/dio_client.dart';
import 'package:fuelsense/data/datasources/local/dao/user_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/bike_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/refuel_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/reserve_cycle_dao.dart';
import 'package:fuelsense/data/datasources/local/dao/pending_operation_dao.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/datasources/remote/auth/auth_api_service.dart';
import 'package:fuelsense/data/datasources/remote/bike/bike_api_service.dart';
import 'package:fuelsense/data/repositories/auth_repository_impl.dart';
import 'package:fuelsense/data/repositories/bike_repository_impl.dart';
import 'package:fuelsense/data/repositories/preferences_repository_impl.dart';
import 'package:fuelsense/data/repositories/profile_repository_impl.dart'
    as data_profile;
import 'package:fuelsense/data/repositories/refuel_repository_impl.dart';
import 'package:fuelsense/data/repositories/reserve_cycle_repository_impl.dart';
import 'package:fuelsense/domain/repositories/auth_repository.dart';
import 'package:fuelsense/domain/repositories/bike_repository.dart';
import 'package:fuelsense/domain/repositories/preferences_repository.dart';
import 'package:fuelsense/domain/repositories/profile_repository.dart'
    as domain_profile;
import 'package:fuelsense/domain/repositories/refuel_repository.dart';
import 'package:fuelsense/domain/repositories/reserve_cycle_repository.dart';
import 'package:fuelsense/domain/usecases/refuel_usecases.dart';
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
import 'package:fuelsense/domain/usecases/bike/sync_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/sync_my_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/bike/sync_pending_bikes_usecase.dart';
import 'package:fuelsense/domain/usecases/profile/get_profile_usecase.dart';
import 'package:fuelsense/domain/usecases/profile/sync_profile_usecase.dart';
import 'package:fuelsense/data/services/connectivity_service.dart';
import 'package:fuelsense/data/services/sync_manager.dart';
import 'package:fuelsense/data/services/handlers/bike/select_bike_handler.dart';
import 'package:fuelsense/data/services/handlers/bike/remove_bike_handler.dart';
import 'package:fuelsense/data/services/handlers/bike/submit_bike_handler.dart';
import 'package:fuelsense/data/services/handlers/bike/edit_bike_handler.dart';
import 'package:fuelsense/data/services/handlers/bike/delete_bike_handler.dart';
import 'package:fuelsense/data/services/handlers/bike/approve_bike_handler.dart';
import 'package:fuelsense/di/setup_di.dart';

void setupRepositories() {
  // Register Dio network client
  getIt.registerLazySingleton<Dio>(() => buildDioClient());

  // Register API services
  getIt.registerLazySingleton<AuthApiService>(() => AuthApiService(getIt<Dio>()));
  getIt.registerLazySingleton<BikeApiService>(() => BikeApiService(getIt<Dio>()));

  // Register services
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  getIt.registerLazySingleton<SyncManager>(
    () => SyncManager(
      getIt<PendingOperationDao>(),
      getIt<ConnectivityService>(),
      getIt<AppSharedPreferences>(),
    ),
  );

  // Register operation handlers
  getIt.registerLazySingleton(
    () => SelectBikeHandler(getIt<BikeApiService>(), getIt<AppSharedPreferences>()),
  );
  getIt.registerLazySingleton(
    () => RemoveBikeHandler(getIt<BikeApiService>(), getIt<AppSharedPreferences>()),
  );
  getIt.registerLazySingleton(
    () => SubmitBikeHandler(
      getIt<BikeApiService>(),
      getIt<BikeDao>(),
      getIt<AppSharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton(
    () => EditBikeHandler(
      getIt<BikeApiService>(),
      getIt<BikeDao>(),
      getIt<AppSharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton(
    () => DeleteBikeHandler(getIt<BikeApiService>(), getIt<AppSharedPreferences>()),
  );
  getIt.registerLazySingleton(
    () => ApproveBikeHandler(getIt<BikeApiService>(), getIt<AppSharedPreferences>()),
  );

  // Register concrete implementations under their abstraction types
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthApiService>()),
  );
  getIt.registerLazySingleton<BikeRepository>(
    () => BikeRepositoryImpl(
      getIt<BikeDao>(),
      getIt<BikeApiService>(),
      getIt<SyncManager>(),
    ),
  );
  getIt.registerLazySingleton<PreferencesRepository>(
    () => PreferencesRepositoryImpl(getIt<AppSharedPreferences>()),
  );
  getIt.registerLazySingleton<domain_profile.ProfileRepository>(
    () => data_profile.ProfileRepositoryImpl(
      getIt<UserDao>(),
      getIt<Dio>(),
    ),
  );
  getIt.registerLazySingleton<RefuelRepository>(
    () => RefuelRepositoryImpl(getIt<RefuelDao>()),
  );
  getIt.registerLazySingleton<ReserveCycleRepository>(
    () => ReserveCycleRepositoryImpl(getIt<ReserveCycleDao>()),
  );

  // Use cases
  getIt.registerLazySingleton(
    () => LoginUseCase(
      getIt<AuthRepository>(),
      getIt<UserDao>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SignupUseCase(
      getIt<AuthRepository>(),
      getIt<UserDao>(),
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
    () => SyncBikesUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SyncMyBikesUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SyncPendingBikesUseCase(
      getIt<BikeRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SyncProfileUseCase(
      getIt<domain_profile.ProfileRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetProfileUseCase(
      getIt<domain_profile.ProfileRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );

  // Refuel use cases
  getIt.registerLazySingleton(
    () => CreateReserveEntryUseCase(
      getIt<RefuelRepository>(),
      getIt<ReserveCycleRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => CompleteReserveEntryUseCase(
      getIt<RefuelRepository>(),
      getIt<ReserveCycleRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => CreateTopupEntryUseCase(
      getIt<RefuelRepository>(),
      getIt<ReserveCycleRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetRefuelHistoryUseCase(getIt<RefuelRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteRefuelUseCase(getIt<RefuelRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetFuelMetricsUseCase(getIt<RefuelRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetCurrentCycleInfoUseCase(
      getIt<ReserveCycleRepository>(),
      getIt<RefuelRepository>(),
    ),
  );

  // Register operation handlers with SyncManager
  final syncManager = getIt<SyncManager>();
  syncManager.registerHandler('selectBike', getIt<SelectBikeHandler>());
  syncManager.registerHandler('removeBike', getIt<RemoveBikeHandler>());
  syncManager.registerHandler('submitBike', getIt<SubmitBikeHandler>());
  syncManager.registerHandler('editBike', getIt<EditBikeHandler>());
  syncManager.registerHandler('deleteBike', getIt<DeleteBikeHandler>());
  syncManager.registerHandler('approveBike', getIt<ApproveBikeHandler>());

  // Initialize SyncManager
  syncManager.init();
}
