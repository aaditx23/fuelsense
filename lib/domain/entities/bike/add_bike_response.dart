import 'package:fuelsense/domain/entities/bike/bike.dart';

class AddBikeResponse {
  final bool success;
  final String message;
  final Bike? data;

  AddBikeResponse({required this.success, required this.message, this.data});
}
