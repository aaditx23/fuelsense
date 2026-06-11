import 'package:fuelsense/data/datasources/local/entity/reserve_cycle_entity.dart';

class ReserveCycle {
  final int? id;
  final int userBikeId;

  // Cycle boundaries
  final DateTime cycleStartDate;
  final DateTime? cycleEndDate; // null = current/ongoing cycle

  // Distance traveled in this cycle
  final double? startTripReading;
  final double? endTripReading; // at reserve
  final double? startOdometerReading;
  final double? endOdometerReading; // at reserve

  // Fuel consumption
  final double totalFuelAdded; // Sum of all refuels in cycle

  // Calculated metrics
  final double? calculatedMileage; // null until cycle completes

  final bool isComplete; // false until reserve hits

  ReserveCycle({
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

  ReserveCycleEntity toEntity() {
    return ReserveCycleEntity(
      id: id,
      userBikeId: userBikeId,
      cycleStartDate: cycleStartDate.millisecondsSinceEpoch,
      cycleEndDate: cycleEndDate?.millisecondsSinceEpoch,
      startTripReading: startTripReading,
      endTripReading: endTripReading,
      startOdometerReading: startOdometerReading,
      endOdometerReading: endOdometerReading,
      totalFuelAdded: totalFuelAdded,
      calculatedMileage: calculatedMileage,
      isComplete: isComplete,
    );
  }

  factory ReserveCycle.fromEntity(ReserveCycleEntity entity) {
    return ReserveCycle(
      id: entity.id,
      userBikeId: entity.userBikeId,
      cycleStartDate: DateTime.fromMillisecondsSinceEpoch(
        entity.cycleStartDate,
      ),
      cycleEndDate: entity.cycleEndDate != null
          ? DateTime.fromMillisecondsSinceEpoch(entity.cycleEndDate!)
          : null,
      startTripReading: entity.startTripReading,
      endTripReading: entity.endTripReading,
      startOdometerReading: entity.startOdometerReading,
      endOdometerReading: entity.endOdometerReading,
      totalFuelAdded: entity.totalFuelAdded,
      calculatedMileage: entity.calculatedMileage,
      isComplete: entity.isComplete,
    );
  }

  ReserveCycle copyWith({
    int? id,
    int? userBikeId,
    DateTime? cycleStartDate,
    DateTime? cycleEndDate,
    double? startTripReading,
    double? endTripReading,
    double? startOdometerReading,
    double? endOdometerReading,
    double? totalFuelAdded,
    double? calculatedMileage,
    bool? isComplete,
  }) {
    return ReserveCycle(
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

  // Calculate distance traveled in this cycle
  double? get distanceTraveled {
    if (endTripReading != null && startTripReading != null) {
      return endTripReading! - startTripReading!;
    }
    if (endOdometerReading != null && startOdometerReading != null) {
      return endOdometerReading! - startOdometerReading!;
    }
    return null;
  }

  // Calculate mileage if cycle is complete
  double? get mileage {
    final distance = distanceTraveled;
    if (distance != null && totalFuelAdded > 0) {
      return distance / totalFuelAdded;
    }
    return calculatedMileage;
  }
}
