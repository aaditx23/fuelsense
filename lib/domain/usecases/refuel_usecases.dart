import 'package:fuelsense/domain/entities/refuel.dart';
import 'package:fuelsense/domain/entities/reserve_cycle.dart';
import 'package:fuelsense/domain/repositories/refuel_repository.dart';
import 'package:fuelsense/domain/repositories/reserve_cycle_repository.dart';

class CreateReserveEntryUseCase {
  final RefuelRepository _refuelRepository;
  final ReserveCycleRepository _cycleRepository;

  CreateReserveEntryUseCase(this._refuelRepository, this._cycleRepository);

  Future<Refuel> execute({
    required int userId,
    required int userBikeId,
    required double? tripMeterAtReserve,
    required double? odometerAtReserve,
  }) async {
    // Check if there's already an incomplete entry
    final existingIncomplete = await _refuelRepository
        .getIncompleteReserveEntry(userBikeId);
    if (existingIncomplete != null) {
      throw Exception(
        'Cannot create new reserve entry while another is incomplete',
      );
    }

    final refuel = Refuel(
      remoteId: DateTime.now().millisecondsSinceEpoch, // Temporary ID
      userId: userId,
      userBikeId: userBikeId,
      tripMeterAtReserve: tripMeterAtReserve,
      odometerAtReserve: odometerAtReserve,
      createdAt: DateTime.now(),
      entryType: RefuelEntryType.reserveIncomplete,
    );

    await _refuelRepository.saveRefuel(refuel);
    return refuel;
  }
}

class CompleteReserveEntryUseCase {
  final RefuelRepository _refuelRepository;
  final ReserveCycleRepository _cycleRepository;

  CompleteReserveEntryUseCase(this._refuelRepository, this._cycleRepository);

  Future<Refuel> execute({
    required int localId,
    required double? tripMeterReading,
    required double? odometerReading,
    required double? fuelLiter,
    required double? fuelPrice,
  }) async {
    // Get the incomplete entry
    final incompleteEntry = await _refuelRepository.getRefuelByLocalId(localId);
    if (incompleteEntry == null || !incompleteEntry.isIncomplete) {
      throw Exception('Invalid or non-existent incomplete reserve entry');
    }

    // Update the entry
    final completedEntry = incompleteEntry.copyWith(
      tripMeterReading: tripMeterReading,
      odometerReading: odometerReading,
      fuelLiter: fuelLiter,
      fuelPrice: fuelPrice,
      entryType: RefuelEntryType.reserveComplete,
    );

    await _refuelRepository.updateRefuel(completedEntry);

    // Close current cycle and create new one
    await _closeCurrentCycleAndCreateNew(
      userBikeId: completedEntry.userBikeId,
      endTrip: completedEntry.tripMeterAtReserve,
      endOdo: completedEntry.odometerAtReserve,
      fuelAdded: fuelLiter ?? 0.0,
    );

    return completedEntry;
  }

  Future<void> _closeCurrentCycleAndCreateNew({
    required int userBikeId,
    required double? endTrip,
    required double? endOdo,
    required double fuelAdded,
  }) async {
    final currentCycle = await _cycleRepository.getCurrentCycle(userBikeId);

    if (currentCycle != null) {
      // Add the fuel to current cycle
      await _cycleRepository.addFuelToCycle(currentCycle.id!, fuelAdded);

      // Complete the cycle
      final mileage =
          currentCycle.mileage; // This will calculate based on current data
      await _cycleRepository.completeCycle(
        currentCycle.id!,
        DateTime.now(),
        endTrip,
        endOdo,
        mileage,
      );
    }

    // Create new cycle
    final newCycle = ReserveCycle(
      userBikeId: userBikeId,
      cycleStartDate: DateTime.now(),
      startTripReading: endTrip,
      startOdometerReading: endOdo,
      totalFuelAdded: fuelAdded,
    );

    await _cycleRepository.saveCycle(newCycle);
  }
}

class CreateTopupEntryUseCase {
  final RefuelRepository _refuelRepository;
  final ReserveCycleRepository _cycleRepository;

  CreateTopupEntryUseCase(this._refuelRepository, this._cycleRepository);

  Future<Refuel> execute({
    required int userId,
    required int userBikeId,
    required double? tripMeterReading,
    required double? odometerReading,
    required double? fuelLiter,
    required double? fuelPrice,
  }) async {
    // Check if there's an incomplete reserve entry (user must complete it first)
    final incompleteEntry = await _refuelRepository.getIncompleteReserveEntry(
      userBikeId,
    );
    if (incompleteEntry != null) {
      throw Exception(
        'Cannot create topup entry while reserve entry is incomplete',
      );
    }

    final refuel = Refuel(
      remoteId: DateTime.now().millisecondsSinceEpoch, // Temporary ID
      userId: userId,
      userBikeId: userBikeId,
      tripMeterReading: tripMeterReading,
      odometerReading: odometerReading,
      fuelLiter: fuelLiter,
      fuelPrice: fuelPrice,
      createdAt: DateTime.now(),
      entryType: RefuelEntryType.topup,
    );

    final localId = await _refuelRepository.saveRefuel(refuel);

    // Add fuel to current cycle
    final currentCycle = await _cycleRepository.getCurrentCycle(userBikeId);
    if (currentCycle != null && fuelLiter != null) {
      await _cycleRepository.addFuelToCycle(currentCycle.id!, fuelLiter);
    }

    return refuel.copyWith(localId: localId);
  }
}

class GetRefuelHistoryUseCase {
  final RefuelRepository _refuelRepository;

  GetRefuelHistoryUseCase(this._refuelRepository);

  Future<List<Refuel>> execute(int userBikeId) async {
    return await _refuelRepository.getRefuelsByBikeId(userBikeId);
  }
}

class DeleteRefuelUseCase {
  final RefuelRepository _refuelRepository;

  DeleteRefuelUseCase(this._refuelRepository);

  Future<void> execute(Refuel refuel) async {
    await _refuelRepository.deleteRefuel(refuel);
  }
}

class GetCurrentCycleInfoUseCase {
  final ReserveCycleRepository _cycleRepository;
  final RefuelRepository _refuelRepository;

  GetCurrentCycleInfoUseCase(this._cycleRepository, this._refuelRepository);

  Future<ReserveCycleInfo?> execute(int userBikeId) async {
    final currentCycle = await _cycleRepository.getCurrentCycle(userBikeId);
    if (currentCycle == null) return null;

    final cycleRefuels = await _refuelRepository.getRefuelsByCycleId(
      currentCycle.id!,
    );

    return ReserveCycleInfo(
      cycle: currentCycle,
      refuels: cycleRefuels,
      totalRefuels: cycleRefuels.length,
    );
  }
}

class GetFuelMetricsUseCase {
  final RefuelRepository _refuelRepository;

  GetFuelMetricsUseCase(this._refuelRepository);

  Future<FuelMetrics> execute(int userBikeId) async {
    final refuels = await _refuelRepository.getRefuelsByBikeId(userBikeId);

    // Filter only completed refuels (reserveComplete and topup)
    final completedRefuels = refuels
        .where(
          (refuel) =>
              refuel.entryType == RefuelEntryType.reserveComplete ||
              refuel.entryType == RefuelEntryType.topup,
        )
        .toList();

    if (completedRefuels.isEmpty) {
      return FuelMetrics.empty();
    }

    // Calculate average mileage
    double totalDistance = 0;
    double totalFuel = 0;

    for (final refuel in completedRefuels) {
      if (refuel.tripMeterReading != null && refuel.fuelLiter != null) {
        totalDistance += refuel.tripMeterReading!;
        totalFuel += refuel.fuelLiter!;
      }
    }

    final averageMileage = totalFuel > 0 ? totalDistance / totalFuel : 0.0;

    // Calculate monthly spending (current month)
    final now = DateTime.now();
    final currentMonthRefuels = completedRefuels
        .where(
          (refuel) =>
              refuel.createdAt.year == now.year &&
              refuel.createdAt.month == now.month,
        )
        .toList();

    double monthlySpending = 0;
    for (final refuel in currentMonthRefuels) {
      if (refuel.fuelPrice != null && refuel.fuelLiter != null) {
        monthlySpending += refuel.fuelPrice! * refuel.fuelLiter!;
      }
    }

    // Calculate total distance (all time)
    final totalDistanceAllTime = totalDistance;

    return FuelMetrics(
      averageMileage: averageMileage,
      monthlySpending: monthlySpending,
      totalDistance: totalDistanceAllTime,
    );
  }
}

class FuelMetrics {
  final double averageMileage;
  final double monthlySpending;
  final double totalDistance;

  FuelMetrics({
    required this.averageMileage,
    required this.monthlySpending,
    required this.totalDistance,
  });

  factory FuelMetrics.empty() {
    return FuelMetrics(
      averageMileage: 0.0,
      monthlySpending: 0.0,
      totalDistance: 0.0,
    );
  }
}

class ReserveCycleInfo {
  final ReserveCycle cycle;
  final List<Refuel> refuels;
  final int totalRefuels;

  ReserveCycleInfo({
    required this.cycle,
    required this.refuels,
    required this.totalRefuels,
  });
}
