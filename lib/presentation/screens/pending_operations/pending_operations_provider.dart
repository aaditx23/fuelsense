import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/data/datasources/local/dao/pending_operation_dao.dart';
import 'package:fuelsense/data/datasources/local/entity/pending_operation_entity.dart';
import 'package:fuelsense/di/setup_di.dart';

// --- Reactive (Stream) provider ---
// Equivalent to Kotlin: viewModel.pendingOperations.collect { ... }
// The list auto-updates whenever a row is inserted or deleted from the queue.
final pendingOperationsStreamProvider =
    StreamProvider<List<PendingOperationEntity>>((ref) {
  return getIt<PendingOperationDao>().watchAllPendingOperations();
});
