import 'package:flutter/widgets.dart';
import 'package:template_flutter/data/model/todo_model.dart';
import 'package:template_flutter/data/repository/placeholder_repository.dart';
import 'package:template_flutter/di/setup_di.dart';

class Screen02Provider with ChangeNotifier {
  final PlaceholderRepository pr = getIt<PlaceholderRepository>();

  TodoModel? _todo = null;
  TodoModel? get todo => _todo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getTodo(int id) async {
    _isLoading = true;
    notifyListeners();
    _todo = await pr.getTodo(id);
    _isLoading = false;
    notifyListeners();
  }
}
