import 'package:floor/floor.dart';

@Entity(
  tableName: "reserve_cycles",
  indices: [
    Index(value: ['userBikeId', 'cycleStartDate']),
  ],
)
class ReserveCycleEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  int userBikeId;

  // Cycle boundaries
  int cycleStartDate;
  int? cycleEndDate; // null = current/ongoing cycle

  // Distance traveled in this cycle
  double? startTripReading;
  double? endTripReading; // at reserve
  double? startOdometerReading;
  double? endOdometerReading; // at reserve

  // Fuel consumption
  double totalFuelAdded; // Sum of all refuels in cycle

  // Calculated metrics
  double? calculatedMileage; // null until cycle completes

  bool isComplete; // false until reserve hits

  ReserveCycleEntity({
    this.id,
    required this.userBikeId,
    required this.cycleStartDate,
    this.cycleEndDate,
    this.startTripReading,
    this.endTripReading,
    this.startOdometerReading,
    this.endOdometerReading,
    this.totalFuelAdded = 0.0,
    this.calculatedMileage,
    this.isComplete = false,
  });

  ReserveCycleEntity copyWith({
    int? id,
    int? userBikeId,
    int? cycleStartDate,
    int? cycleEndDate,
    double? startTripReading,
    double? endTripReading,
    double? startOdometerReading,
    double? endOdometerReading,
    double? totalFuelAdded,
    double? calculatedMileage,
    bool? isComplete,
  }) {
    return ReserveCycleEntity(
      id: id ?? this.id,
      userBikeId: userBikeId ?? this.userBikeId,
      cycleStartDate: cycleStartDate ?? this.cycleStartDate,
      cycleEndDate: cycleEndDate ?? this.cycleEndDate,
      startTripReading: startTripReading ?? this.startTripReading,
      endTripReading: endTripReading ?? this.endTripReading,
      startOdometerReading: startOdometerReading ?? this.startOdometerReading,
      endOdometerReading: endOdometerReading ?? this.endOdometerReading,
      totalFuelAdded: totalFuelAdded ?? this.totalFuelAdded,
      calculatedMileage: calculatedMileage ?? this.calculatedMileage,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
