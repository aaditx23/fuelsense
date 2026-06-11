import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/domain/entities/refuel.dart';
import 'package:fuelsense/domain/usecases/refuel_usecases.dart';
import 'package:fuelsense/domain/repositories/refuel_repository.dart';
import 'package:fuelsense/di/setup_di.dart';

class RefuelDashboardState {
  final FuelMetrics? metrics;
  final List<Refuel> recentRefuels;
  final String? error;

  RefuelDashboardState({
    this.metrics,
    this.recentRefuels = const [],
    this.error,
  });

  RefuelDashboardState copyWith({
    FuelMetrics? metrics,
    List<Refuel>? recentRefuels,
    String? error,
  }) {
    return RefuelDashboardState(
      metrics: metrics ?? this.metrics,
      recentRefuels: recentRefuels ?? this.recentRefuels,
      error: error,
    );
  }
}

// StreamProvider to watch refuel changes from DB
final refuelStreamProvider = StreamProvider.family<List<Refuel>, int>((
  ref,
  userBikeId,
) {
  final repository = getIt<RefuelRepository>();
  // Use the repository's watch method for real-time updates
  return repository.watchRefuelsByBikeId(userBikeId);
});

// Provider for fuel metrics
final fuelMetricsProvider = FutureProvider.family<FuelMetrics, int>((
  ref,
  userBikeId,
) async {
  final useCase = getIt<GetFuelMetricsUseCase>();
  return await useCase.execute(userBikeId);
});

// Dashboard state provider that combines metrics and recent refuels
final refuelDashboardProvider =
    Provider.family<AsyncValue<RefuelDashboardState>, int>((ref, userBikeId) {
      final refuelsAsync = ref.watch(refuelStreamProvider(userBikeId));
      final metricsAsync = ref.watch(fuelMetricsProvider(userBikeId));

      return refuelsAsync.when(
        data: (refuels) {
          return metricsAsync.when(
            data: (metrics) => AsyncValue.data(
              RefuelDashboardState(
                metrics: metrics,
                recentRefuels: refuels.take(3).toList(),
              ),
            ),
            loading: () => const AsyncValue.loading(),
            error: (e, st) => AsyncValue.error(e, st),
          );
        },
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
      );
    });
