class Bike {
  final int id;
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

  Bike({
    required this.id,
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
  });
}
