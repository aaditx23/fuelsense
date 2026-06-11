import '../datasources/local/entity/pending_operation_entity.dart';

abstract class OperationHandler {
  Future<void> execute(PendingOperationEntity operation);
}
