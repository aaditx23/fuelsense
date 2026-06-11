import 'package:json_annotation/json_annotation.dart';

part 'bike_request.g.dart';

@JsonSerializable()
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

  factory BikeRequest.fromJson(Map<String, dynamic> json) =>
      _$BikeRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BikeRequestToJson(this);
}
