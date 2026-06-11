class BikeEntity {
  int? localId;
  final int remoteId;
  final String brand;
  final String model;
  final int engineCc;
  final int modelYear;
  final String fuelType;
  final double expectedMileage;
  final double tankCapacity;
  final double? reserveCapacity;
  final String? image;
  final int? submittedBy;
  final String? adminNote;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final bool isMine;
  final bool isPending;

  BikeEntity({
    this.localId,
    required this.remoteId,
    required this.brand,
    required this.model,
    required this.engineCc,
    required this.modelYear,
    required this.fuelType,
    required this.expectedMileage,
    required this.tankCapacity,
    this.reserveCapacity,
    this.image,
    this.submittedBy,
    this.adminNote,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.isMine,
    required this.isPending,
  });

  factory BikeEntity.fromJson(Map<String, dynamic> json, [int? localKey]) {
    return BikeEntity(
      localId: localKey ?? json['localId'] as int?,
      remoteId: json['remoteId'] as int,
      brand: json['brand'] as String,
      model: json['model'] as String,
      engineCc: json['engineCc'] as int,
      modelYear: json['modelYear'] as int,
      fuelType: json['fuelType'] as String,
      expectedMileage: (json['expectedMileage'] as num).toDouble(),
      tankCapacity: (json['tankCapacity'] as num).toDouble(),
      reserveCapacity: json['reserveCapacity'] != null 
          ? (json['reserveCapacity'] as num).toDouble() 
          : null,
      image: json['image'] as String?,
      submittedBy: json['submittedBy'] as int?,
      adminNote: json['adminNote'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isMine: json['isMine'] as bool,
      isPending: json['isPending'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'remoteId': remoteId,
      'brand': brand,
      'model': model,
      'engineCc': engineCc,
      'modelYear': modelYear,
      'fuelType': fuelType,
      'expectedMileage': expectedMileage,
      'tankCapacity': tankCapacity,
      'reserveCapacity': reserveCapacity,
      'image': image,
      'submittedBy': submittedBy,
      'adminNote': adminNote,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isMine': isMine,
      'isPending': isPending,
    };
  }

  BikeEntity copyWith({
    int? localId,
    int? remoteId,
    String? brand,
    String? model,
    int? engineCc,
    int? modelYear,
    String? fuelType,
    double? expectedMileage,
    double? tankCapacity,
    double? reserveCapacity,
    String? image,
    int? submittedBy,
    String? adminNote,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    bool? isMine,
    bool? isPending,
  }) {
    return BikeEntity(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      engineCc: engineCc ?? this.engineCc,
      modelYear: modelYear ?? this.modelYear,
      fuelType: fuelType ?? this.fuelType,
      expectedMileage: expectedMileage ?? this.expectedMileage,
      tankCapacity: tankCapacity ?? this.tankCapacity,
      reserveCapacity: reserveCapacity ?? this.reserveCapacity,
      image: image ?? this.image,
      submittedBy: submittedBy ?? this.submittedBy,
      adminNote: adminNote ?? this.adminNote,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isMine: isMine ?? this.isMine,
      isPending: isPending ?? this.isPending,
    );
  }
}
