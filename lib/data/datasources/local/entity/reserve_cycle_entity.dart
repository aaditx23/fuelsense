class ReserveCycleEntity {
  int? id;
  int userBikeId;
  int cycleStartDate;
  int? cycleEndDate; // null = current/ongoing cycle
  double? startTripReading;
  double? endTripReading; // at reserve
  double? startOdometerReading;
  double? endOdometerReading; // at reserve
  double totalFuelAdded; // Sum of all refuels in cycle
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

  factory ReserveCycleEntity.fromJson(Map<String, dynamic> json, [int? localKey]) {
    return ReserveCycleEntity(
      id: localKey ?? json['id'] as int?,
      userBikeId: json['userBikeId'] as int,
      cycleStartDate: json['cycleStartDate'] as int,
      cycleEndDate: json['cycleEndDate'] as int?,
      startTripReading: json['startTripReading'] != null 
          ? (json['startTripReading'] as num).toDouble() 
          : null,
      endTripReading: json['endTripReading'] != null 
          ? (json['endTripReading'] as num).toDouble() 
          : null,
      startOdometerReading: json['startOdometerReading'] != null 
          ? (json['startOdometerReading'] as num).toDouble() 
          : null,
      endOdometerReading: json['endOdometerReading'] != null 
          ? (json['endOdometerReading'] as num).toDouble() 
          : null,
      totalFuelAdded: (json['totalFuelAdded'] as num).toDouble(),
      calculatedMileage: json['calculatedMileage'] != null 
          ? (json['calculatedMileage'] as num).toDouble() 
          : null,
      isComplete: json['isComplete'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userBikeId': userBikeId,
      'cycleStartDate': cycleStartDate,
      'cycleEndDate': cycleEndDate,
      'startTripReading': startTripReading,
      'endTripReading': endTripReading,
      'startOdometerReading': startOdometerReading,
      'endOdometerReading': endOdometerReading,
      'totalFuelAdded': totalFuelAdded,
      'calculatedMileage': calculatedMileage,
      'isComplete': isComplete,
    };
  }

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
