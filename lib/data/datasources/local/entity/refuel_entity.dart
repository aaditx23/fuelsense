import 'package:floor/floor.dart';

@Entity(
  tableName: "fuel_records",
  indices: [
    Index(value: ['remoteId'], unique: true),
  ],
)
class RefuelEntity {
  @PrimaryKey(autoGenerate: true)
  int? localId;
  int remoteId;
  int userId;
  int userBikeId;
  double? odometerReading;
  double? tripMeterReading;
  double? tripMeterAtReserve;
  double? odometerAtReserve;
  double? fuelLiter;
  double? fuelPrice;
  int createdAt; // timestamp in milliseconds

  // Entry type: 'RESERVE_INCOMPLETE', 'RESERVE_COMPLETE', 'TOPUP'
  String entryType;

  // Links entries in the same reserve cycle
  int? reserveCycleId;

  RefuelEntity({
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

  RefuelEntity copyWith({
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
    int? createdAt,
    String? entryType,
    int? reserveCycleId,
  }) {
    return RefuelEntity(
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
}
