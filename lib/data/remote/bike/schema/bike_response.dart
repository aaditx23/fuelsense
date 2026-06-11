import 'package:fuelsense/data/remote/bike/schema/bike_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bike_response.g.dart';

@JsonSerializable()
class BikeResponse {
  final bool success;
  final String message;
  final List<BikeModel>? data;

  BikeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BikeResponse.fromJson(Map<String, dynamic> json) => _$BikeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BikeResponseToJson(this);
}