import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;
import 'package:flutter_riverpod/legacy.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/domain/entities/refuel.dart';
import 'package:fuelsense/domain/repositories/refuel_repository.dart';
import 'package:fuelsense/domain/usecases/refuel_usecases.dart';

enum CreateRefuelType { reserveHit, refuel, topup }

class CreateRefuelState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final CreateRefuelType refuelType;
  final Refuel? incompleteEntry; // Track incomplete reserve entry

  // Form fields
  final double? tripMeterReading;
  final double? odometerReading;
  final double? fuelLiter;
  final double? fuelPrice; // total cost
  final double? fuelPricePerLiter; // price per liter (mandatory)

  CreateRefuelState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.refuelType = CreateRefuelType.reserveHit,
    this.incompleteEntry,
    this.tripMeterReading,
    this.odometerReading,
    this.fuelLiter,
    this.fuelPrice,
    this.fuelPricePerLiter,
  });

  CreateRefuelState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    CreateRefuelType? refuelType,
    Refuel? incompleteEntry,
    double? tripMeterReading,
    double? odometerReading,
    double? fuelLiter,
    double? fuelPrice,
    double? fuelPricePerLiter,
    bool clearIncomplete = false,
    bool clearTripMeter = false,
    bool clearOdometer = false,
    bool clearFuelLiter = false,
    bool clearFuelPrice = false,
    bool clearFuelPricePerLiter = false,
  }) {
    return CreateRefuelState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      refuelType: refuelType ?? this.refuelType,
      incompleteEntry: clearIncomplete
          ? null
          : (incompleteEntry ?? this.incompleteEntry),
      tripMeterReading: clearTripMeter
          ? null
          : (tripMeterReading ?? this.tripMeterReading),
      odometerReading: clearOdometer
          ? null
          : (odometerReading ?? this.odometerReading),
      fuelLiter: clearFuelLiter ? null : (fuelLiter ?? this.fuelLiter),
      fuelPrice: clearFuelPrice ? null : (fuelPrice ?? this.fuelPrice),
      fuelPricePerLiter: clearFuelPricePerLiter
          ? null
          : (fuelPricePerLiter ?? this.fuelPricePerLiter),
    );
  }

  bool get hasIncompleteEntry => incompleteEntry != null;

  bool get _hasFuelAmount => (fuelLiter ?? 0.0) > 0 || (fuelPrice ?? 0.0) > 0;

  bool get isFormValid {
    if (hasIncompleteEntry) {
      return (tripMeterReading != null || odometerReading != null) &&
          fuelPricePerLiter != null &&
          _hasFuelAmount;
    }

    switch (refuelType) {
      case CreateRefuelType.reserveHit:
        return tripMeterReading != null || odometerReading != null;
      case CreateRefuelType.refuel:
        return (tripMeterReading != null || odometerReading != null) &&
            fuelPricePerLiter != null &&
            _hasFuelAmount;
      case CreateRefuelType.topup:
        return (tripMeterReading != null || odometerReading != null) &&
            fuelPricePerLiter != null &&
            _hasFuelAmount;
    }
  }
}

class CreateRefuelNotifier extends StateNotifier<CreateRefuelState> {
  final CreateReserveEntryUseCase _createReserveEntryUseCase;
  final CompleteReserveEntryUseCase _completeReserveEntryUseCase;
  final CreateTopupEntryUseCase _createTopupEntryUseCase;
  final RefuelRepository _refuelRepository;

  CreateRefuelNotifier(
    this._createReserveEntryUseCase,
    this._completeReserveEntryUseCase,
    this._createTopupEntryUseCase,
    this._refuelRepository,
  ) : super(CreateRefuelState());

  Future<void> checkIncompleteEntry(int userBikeId) async {
    state = state.copyWith(isLoading: true);
    try {
      final incomplete = await _refuelRepository.getIncompleteReserveEntry(
        userBikeId,
      );
      if (incomplete != null) {
        // Load the incomplete entry data
        state = state.copyWith(
          isLoading: false,
          incompleteEntry: incomplete,
          refuelType: CreateRefuelType.refuel,
          tripMeterReading: incomplete.tripMeterAtReserve,
          odometerReading: incomplete.odometerAtReserve,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateRefuelType(CreateRefuelType type) {
    if (!state.hasIncompleteEntry) {
      state = state.copyWith(
        refuelType: type,
        error: null,
        successMessage: null,
      );
    }
  }

  void updateTripMeterReading(double? value) {
    state = state.copyWith(
      tripMeterReading: value,
      clearTripMeter: value == null,
    );
  }

  void updateOdometerReading(double? value) {
    state = state.copyWith(
      odometerReading: value,
      clearOdometer: value == null,
    );
  }

  /// Called by OdometerField when the value is auto-calculated from trip meter.
  /// Only updates state if the user has not manually entered an odometer value.
  void updateCalculatedOdometer(double? value) {
    // Don't overwrite a manually entered odometer
    if (value == null) {
      state = state.copyWith(clearOdometer: true);
    } else {
      state = state.copyWith(odometerReading: value);
    }
  }

  void updateFuelLiter(double? value) {
    state = state.copyWith(fuelLiter: value, clearFuelLiter: value == null);
  }

  void updateFuelPrice(double? value) {
    state = state.copyWith(fuelPrice: value, clearFuelPrice: value == null);
  }

  void updateFuelPricePerLiter(double? value) {
    state = state.copyWith(
      fuelPricePerLiter: value,
      clearFuelPricePerLiter: value == null,
    );
  }

  Future<bool> submitEntry(int userId, int userBikeId) async {
    if (!state.isFormValid) {
      state = state.copyWith(error: 'Please fill in all required fields');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      if (state.hasIncompleteEntry) {
        // Complete the incomplete entry
        await _completeReserveEntryUseCase.execute(
          localId: state.incompleteEntry!.localId!,
          tripMeterReading: state.tripMeterReading,
          odometerReading: state.odometerReading,
          fuelLiter: state.fuelLiter,
          fuelPrice: state.fuelPricePerLiter, // price per liter → DB fuelPrice
        );
      } else {
        switch (state.refuelType) {
          case CreateRefuelType.reserveHit:
            await _createReserveEntryUseCase.execute(
              userId: userId,
              userBikeId: userBikeId,
              tripMeterAtReserve: state.tripMeterReading,
              odometerAtReserve: state.odometerReading,
            );
            break;

          case CreateRefuelType.refuel:
          case CreateRefuelType.topup:
            await _createTopupEntryUseCase.execute(
              userId: userId,
              userBikeId: userBikeId,
              tripMeterReading: state.tripMeterReading,
              odometerReading: state.odometerReading,
              fuelLiter: state.fuelLiter,
              fuelPrice: state.fuelPricePerLiter,
              entryType: state.refuelType == CreateRefuelType.refuel
                  ? RefuelEntryType.reserveComplete
                  : RefuelEntryType.topup,
            );
            break;
        }
      }

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Entry saved successfully',
        clearIncomplete: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void reset() {
    state = CreateRefuelState();
  }
}

final createRefuelNotifierProvider =
    StateNotifierProvider.autoDispose<CreateRefuelNotifier, CreateRefuelState>((
      ref,
    ) {
      return CreateRefuelNotifier(
        getIt<CreateReserveEntryUseCase>(),
        getIt<CompleteReserveEntryUseCase>(),
        getIt<CreateTopupEntryUseCase>(),
        getIt<RefuelRepository>(),
      );
    });

/// Holds the last recorded odometer and trip meter from the same entry.
class LastMeterReadings {
  final double? odometer;
  final double? tripMeter;
  const LastMeterReadings({this.odometer, this.tripMeter});
}

// Provider to get the last odometer reading for validation
final lastOdometerReadingProvider = FutureProvider.autoDispose
    .family<double?, int>((ref, userBikeId) async {
      final readings = await ref.watch(
        lastMeterReadingsProvider(userBikeId).future,
      );
      return readings.odometer;
    });

// Provider to get the last trip meter reading for odometer auto-calculation
final lastTripMeterReadingProvider = FutureProvider.autoDispose
    .family<double?, int>((ref, userBikeId) async {
      final readings = await ref.watch(
        lastMeterReadingsProvider(userBikeId).future,
      );
      return readings.tripMeter;
    });

// Single source of truth — both readings come from the same entry so
// the odometer delta calculation is never misaligned.
final lastMeterReadingsProvider = FutureProvider.autoDispose
    .family<LastMeterReadings, int>((ref, userBikeId) async {
      final repository = getIt<RefuelRepository>();
      final refuels = await repository.getRefuelsByBikeId(userBikeId);

      for (final refuel in refuels) {
        // Pick the appropriate trip and odo fields based on entry type
        final trip = refuel.tripMeterReading ?? refuel.tripMeterAtReserve;
        final odo = refuel.odometerReading ?? refuel.odometerAtReserve;
        // Only use an entry that has at least an odometer reading
        if (odo != null) {
          return LastMeterReadings(odometer: odo, tripMeter: trip);
        }
      }
      return const LastMeterReadings();
    });

// Provider to check if this is the first refuel entry
final isFirstRefuelEntryProvider = FutureProvider.autoDispose.family<bool, int>(
  (ref, userBikeId) async {
    final repository = getIt<RefuelRepository>();
    final refuels = await repository.getRefuelsByBikeId(userBikeId);
    return refuels.isEmpty;
  },
);
