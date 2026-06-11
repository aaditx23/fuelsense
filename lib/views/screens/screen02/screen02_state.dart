import 'package:fuelsense/data/model/todo_model.dart';

class Screen02State {
  TodoModel? todo;
  bool isLoading = false;

  Screen02State({this.todo, required this.isLoading});

  Screen02State copyWith({TodoModel? todo, bool? isLoading}) {
    return Screen02State(
      todo: todo ?? this.todo,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
