class BikeRequest {
  final String brand;
  final String model;
  final int engineCc;
  final int modelYear;
  final String fuelType;
  final double expectedMileage;
  final double tankCapacity;
  final double? reserveCapacity;
  final String? image;

  BikeRequest({
    required this.brand,
    required this.model,
    required this.engineCc,
    required this.modelYear,
    required this.fuelType,
    required this.expectedMileage,
    required this.tankCapacity,
    this.reserveCapacity,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'engineCc': engineCc,
      'modelYear': modelYear,
      'fuelType': fuelType,
      'expectedMileage': expectedMileage,
      'tankCapacity': tankCapacity,
      'reserveCapacity': reserveCapacity,
      'image': image,
    };
  }
}
