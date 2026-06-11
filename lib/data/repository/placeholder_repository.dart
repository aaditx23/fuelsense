import 'dart:convert';

import 'package:template_flutter/data/model/todo_model.dart';
import "package:http/http.dart" as http;

class PlaceholderRepository {
  Future<TodoModel?> getTodo(int id) async {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/todos/$id"),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return TodoModel.fromJson(json);
    }
    return null;
  }
}
