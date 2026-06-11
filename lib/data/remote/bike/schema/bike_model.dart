import 'package:fuelsense/data/local/entity/bike_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bike_model.g.dart';

@JsonSerializable()
class BikeModel {
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

  BikeModel({
    required this.brand,
    required this.model,
    required this.engineCc,
    required this.modelYear,
    required this.fuelType,
    required this.expectedMileage,
    required this.tankCapacity,
    this.reserveCapacity,
    this.image,
    required this.id,
    this.submittedBy,
    this.adminNote,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BikeModel.fromJson(Map<String, dynamic> json) => _$BikeModelFromJson(json);
  Map<String, dynamic> toJson() => _$BikeModelToJson(this);

  BikeEntity toEntity() {
    return BikeEntity(
      id: id,
      brand: brand,
      model: model,
      engineCc: engineCc,
      modelYear: modelYear,
      fuelType: fuelType,
      expectedMileage: expectedMileage,
      tankCapacity: tankCapacity,
      reserveCapacity: reserveCapacity,
      image: image,
      submittedBy: submittedBy,
      adminNote: adminNote,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }
}
