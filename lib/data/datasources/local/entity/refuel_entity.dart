class RefuelEntity {
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
  String entryType; // 'RESERVE_INCOMPLETE', 'RESERVE_COMPLETE', 'TOPUP'
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

  factory RefuelEntity.fromJson(Map<String, dynamic> json, [int? localKey]) {
    return RefuelEntity(
      localId: localKey ?? json['localId'] as int?,
      remoteId: json['remoteId'] as int,
      userId: json['userId'] as int,
      userBikeId: json['userBikeId'] as int,
      odometerReading: json['odometerReading'] != null 
          ? (json['odometerReading'] as num).toDouble() 
          : null,
      tripMeterReading: json['tripMeterReading'] != null 
          ? (json['tripMeterReading'] as num).toDouble() 
          : null,
      tripMeterAtReserve: json['tripMeterAtReserve'] != null 
          ? (json['tripMeterAtReserve'] as num).toDouble() 
          : null,
      odometerAtReserve: json['odometerAtReserve'] != null 
          ? (json['odometerAtReserve'] as num).toDouble() 
          : null,
      fuelLiter: json['fuelLiter'] != null 
          ? (json['fuelLiter'] as num).toDouble() 
          : null,
      fuelPrice: json['fuelPrice'] != null 
          ? (json['fuelPrice'] as num).toDouble() 
          : null,
      createdAt: json['createdAt'] as int,
      entryType: json['entryType'] as String,
      reserveCycleId: json['reserveCycleId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'userId': userId,
      'userBikeId': userBikeId,
      'odometerReading': odometerReading,
      'tripMeterReading': tripMeterReading,
      'tripMeterAtReserve': tripMeterAtReserve,
      'odometerAtReserve': odometerAtReserve,
      'fuelLiter': fuelLiter,
      'fuelPrice': fuelPrice,
      'createdAt': createdAt,
      'entryType': entryType,
      'reserveCycleId': reserveCycleId,
    };
  }

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
