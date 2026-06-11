import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/entities/refuel.dart';
import 'package:fuelsense/domain/repositories/refuel_repository.dart';
import 'package:fuelsense/domain/usecases/refuel_usecases.dart';

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
  return repository.watchRefuelsByBikeId(userBikeId);
});

// StreamProvider for fuel metrics — derived reactively from the DB stream.
// Recalculates every time the refuel list changes (no extra DB call needed).
final fuelMetricsProvider = StreamProvider.family<FuelMetrics, int>((
  ref,
  userBikeId,
) {
  final repository = getIt<RefuelRepository>();
  return repository.watchRefuelsByBikeId(userBikeId).map((refuels) {
    final completedRefuels = refuels
        .where(
          (r) =>
              r.entryType == RefuelEntryType.reserveComplete ||
              r.entryType == RefuelEntryType.topup,
        )
        .toList();

    if (completedRefuels.isEmpty) return FuelMetrics.empty();

    // Average mileage
    double totalDistance = 0;
    double totalFuel = 0;
    for (final r in completedRefuels) {
      if (r.tripMeterReading != null && r.fuelLiter != null) {
        totalDistance += r.tripMeterReading!;
        totalFuel += r.fuelLiter!;
      }
    }
    final averageMileage = totalFuel > 0 ? totalDistance / totalFuel : 0.0;

    // Monthly spending (current month)
    final now = DateTime.now();
    double monthlySpending = 0;
    for (final r in completedRefuels) {
      if (r.createdAt.year == now.year &&
          r.createdAt.month == now.month &&
          r.fuelPrice != null &&
          r.fuelLiter != null) {
        monthlySpending += r.fuelPrice! * r.fuelLiter!;
      }
    }

    return FuelMetrics(
      averageMileage: averageMileage,
      monthlySpending: monthlySpending,
      totalDistance: totalDistance,
    );
  });
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
