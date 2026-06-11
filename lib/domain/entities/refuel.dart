import 'package:fuelsense/data/datasources/local/entity/refuel_entity.dart';

enum RefuelEntryType {
  reserveIncomplete('RESERVE_INCOMPLETE'),
  reserveComplete('RESERVE_COMPLETE'),
  topup('TOPUP');

  const RefuelEntryType(this.value);
  final String value;

  static RefuelEntryType fromString(String value) {
    return RefuelEntryType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => RefuelEntryType.topup,
    );
  }
}

class Refuel {
  final int? localId;
  final int remoteId;
  final int userId;
  final int userBikeId;

  // Current readings (when refueling or topping up)
  final double? odometerReading;
  final double? tripMeterReading;

  // Reserve markers (only when reserve hits)
  final double? tripMeterAtReserve;
  final double? odometerAtReserve;

  // Fuel data
  final double? fuelLiter;
  final double? fuelPrice;

  // Entry metadata
  final DateTime createdAt;
  final RefuelEntryType entryType;

  // Links entries in the same reserve cycle
  final int? reserveCycleId;

  Refuel({
    this.localId,
    required this.remoteId,
    required this.userId,
    required this.userBikeId,
    this.odometerReading,
    this.tripMeterReading,
    this.tripMeterAtReserve,
    this.odometerAtReserve,
    this.fuelLiter,
    this.fuelPrice,
    required this.createdAt,
    required this.entryType,
    this.reserveCycleId,
  });

  RefuelEntity toEntity() {
    return RefuelEntity(
      localId: localId,
      remoteId: remoteId,
      userId: userId,
      userBikeId: userBikeId,
      odometerReading: odometerReading,
      tripMeterReading: tripMeterReading,
      tripMeterAtReserve: tripMeterAtReserve,
      odometerAtReserve: odometerAtReserve,
      fuelLiter: fuelLiter,
      fuelPrice: fuelPrice,
      createdAt: createdAt.millisecondsSinceEpoch,
      entryType: entryType.value,
      reserveCycleId: reserveCycleId,
    );
  }

  factory Refuel.fromEntity(RefuelEntity entity) {
    return Refuel(
      localId: entity.localId,
      remoteId: entity.remoteId,
      userId: entity.userId,
      userBikeId: entity.userBikeId,
      odometerReading: entity.odometerReading,
      tripMeterReading: entity.tripMeterReading,
      tripMeterAtReserve: entity.tripMeterAtReserve,
      odometerAtReserve: entity.odometerAtReserve,
      fuelLiter: entity.fuelLiter,
      fuelPrice: entity.fuelPrice,
      createdAt: DateTime.fromMillisecondsSinceEpoch(entity.createdAt),
      entryType: RefuelEntryType.fromString(entity.entryType),
      reserveCycleId: entity.reserveCycleId,
    );
  }

  Refuel copyWith({
    int? localId,
    int? remoteId,
    int? userId,
    int? userBikeId,
    double? odometerReading,
    double? tripMeterReading,
    double? tripMeterAtReserve,
    double? odometerAtReserve,
    double? fuelLiter,
    double? fuelPrice,
    DateTime? createdAt,
    RefuelEntryType? entryType,
    int? reserveCycleId,
  }) {
    return Refuel(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      userId: userId ?? this.userId,
      userBikeId: userBikeId ?? this.userBikeId,
      odometerReading: odometerReading ?? this.odometerReading,
      tripMeterReading: tripMeterReading ?? this.tripMeterReading,
      tripMeterAtReserve: tripMeterAtReserve ?? this.tripMeterAtReserve,
      odometerAtReserve: odometerAtReserve ?? this.odometerAtReserve,
      fuelLiter: fuelLiter ?? this.fuelLiter,
      fuelPrice: fuelPrice ?? this.fuelPrice,
      createdAt: createdAt ?? this.createdAt,
      entryType: entryType ?? this.entryType,
      reserveCycleId: reserveCycleId ?? this.reserveCycleId,
    );
  }

  // Helper methods
  bool get isIncomplete => entryType == RefuelEntryType.reserveIncomplete;
  bool get isReserveComplete => entryType == RefuelEntryType.reserveComplete;
  bool get isTopup => entryType == RefuelEntryType.topup;
  bool get hasReserveMarker =>
      tripMeterAtReserve != null || odometerAtReserve != null;
  bool get hasRefuelData => fuelLiter != null || fuelPrice != null;
}
