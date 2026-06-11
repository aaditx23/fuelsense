import 'package:fuelsense/data/models/bike/bike_model.dart' as data_bike;
import 'package:fuelsense/data/models/bike/bike_request.dart' as data_request;
import 'package:fuelsense/data/models/bike/bike_response.dart' as data_response;
import 'package:fuelsense/domain/entities/bike/add_bike_response.dart';
import 'package:fuelsense/domain/entities/bike/bike.dart';
import 'package:fuelsense/domain/entities/bike/bike_request.dart';
import 'package:fuelsense/domain/entities/bike/bike_response.dart';

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
    );
  }

  static BikeResponse toDomainBikeResponse(data_response.BikeResponse data) {
    return BikeResponse(
      success: data.success,
      message: data.message,
      listData: data.listData?.map(toDomainBike).toList(),
    );
  }

  static AddBikeResponse toDomainAddBikeResponse(
    data_response.AddBikeResponse data,
  ) {
    return AddBikeResponse(
      success: data.success,
      message: data.message,
      data: data.data != null ? toDomainBike(data.data!) : null,
    );
  }
}
