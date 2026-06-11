import 'package:fuelsense/data/models/bike/bike_model.dart' as data_bike;
import 'package:fuelsense/data/models/bike/bike_request.dart' as data_request;
import 'package:fuelsense/data/models/bike/bike_response.dart' as data_response;
import 'package:fuelsense/domain/entities/bike/bike.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/domain/entities/bike/bike_response.dart';
import 'package:fuelsense/data/datasources/local/entity/bike_entity.dart';

class BikeMapper {
  static data_request.BikeRequest toDataBikeRequest(BikeRequest domain) {
    return data_request.BikeRequest(
      brand: domain.brand,
      model: domain.model,
      engineCc: domain.engineCc,
      modelYear: domain.modelYear,
      fuelType: domain.fuelType,
      expectedMileage: domain.expectedMileage,
      tankCapacity: domain.tankCapacity,
      reserveCapacity: domain.reserveCapacity,
      image: domain.image,
    );
  }

  static Bike toDomainBike(data_bike.BikeModel data) {
    return Bike(
      id: data.id,
      brand: data.brand,
      model: data.model,
      engineCc: data.engineCc,
      modelYear: data.modelYear,
      fuelType: data.fuelType,
      expectedMileage: data.expectedMileage,
      tankCapacity: data.tankCapacity,
      reserveCapacity: data.reserveCapacity,
      image: data.image,
      submittedBy: data.submittedBy,
      adminNote: data.adminNote,
      isActive: data.isActive,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isMine: data.isMine,
      isPending: data.isPending,
    );
  }

  static Bike toDomainBikeFromEntity(BikeEntity entity) {
    return Bike(
      id: entity.remoteId,
      brand: entity.brand,
      model: entity.model,
      engineCc: entity.engineCc,
      modelYear: entity.modelYear,
      fuelType: entity.fuelType,
      expectedMileage: entity.expectedMileage,
      tankCapacity: entity.tankCapacity,
      reserveCapacity: entity.reserveCapacity,
      image: entity.image,
      submittedBy: entity.submittedBy,
      adminNote: entity.adminNote,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isMine: entity.isMine,
      isPending: entity.isPending,
    );
  }

  static BikeResponse toDomainBikeResponse(data_response.BikeResponse data) {
    return BikeResponse(
      success: data.success,
      message: data.message,
      listData: data.listData?.map(toDomainBike).toList(),
    );
  }

  static BikeEntity toEntityFromDataModel(
    data_bike.BikeModel data, {
    bool isMine = false,
    bool isPending = false,
  }) {
    return BikeEntity(
      remoteId: data.id,
      brand: data.brand,
      model: data.model,
      engineCc: data.engineCc,
      modelYear: data.modelYear,
      fuelType: data.fuelType,
      expectedMileage: data.expectedMileage,
      tankCapacity: data.tankCapacity,
      reserveCapacity: data.reserveCapacity,
      image: data.image,
      submittedBy: data.submittedBy,
      adminNote: data.adminNote,
      isActive: data.isActive,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isMine: isMine,
      isPending: isPending,
    );
  }
}
