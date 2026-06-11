import "package:json_annotation/json_annotation.dart";

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return _$TodoModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$TodoModelToJson(this);
  }
}
