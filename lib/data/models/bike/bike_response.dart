import 'package:fuelsense/data/models/bike/bike_model.dart';
import 'package:fuelsense/data/models/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bike_response.g.dart';

@JsonSerializable()
class BikeResponse extends BaseResponse {
  final List<BikeModel>? listData;

  BikeResponse({required super.success, required super.message, this.listData});

  factory BikeResponse.fromJson(Map<String, dynamic> json) =>
      _$BikeResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$BikeResponseToJson(this);
}

@JsonSerializable()
class AddBikeResponse extends BaseResponse {
  final BikeModel? data;

  AddBikeResponse({required super.success, required super.message, this.data});

  factory AddBikeResponse.fromJson(Map<String, dynamic> json) =>
      _$AddBikeResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddBikeResponseToJson(this);
}
