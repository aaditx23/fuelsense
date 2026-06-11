import 'package:fuelsense/domain/entities/bike/bike.dart';

class BikeResponse {
  final bool success;
  final String message;
  final List<Bike>? listData;

  BikeResponse({required this.success, required this.message, this.listData});
}
