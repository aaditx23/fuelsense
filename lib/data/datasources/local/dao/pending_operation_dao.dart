import 'package:floor/floor.dart';
import '../entity/pending_operation_entity.dart';

@dao
abstract class PendingOperationDao {
  @Insert()
  Future<int> insertOperation(PendingOperationEntity operation);

  @Insert()
  Future<void> insertOperations(List<PendingOperationEntity> operations);

  @Query('SELECT * FROM pending_operations ORDER BY createdAt ASC')
  Future<List<PendingOperationEntity>> getAllPendingOperations();

  @Query('SELECT * FROM pending_operations WHERE id = :id')
  Future<PendingOperationEntity?> getOperationById(int id);

  @delete
  Future<int> deleteOperation(PendingOperationEntity operation);

  @Query('DELETE FROM pending_operations WHERE id = :id')
  Future<void> deleteOperationById(int id);

  @Query('DELETE FROM pending_operations')
  Future<void> deleteAllOperations();

  @update
  Future<int> updateOperation(PendingOperationEntity operation);

  @Query('SELECT COUNT(*) FROM pending_operations')
  Future<int?> getPendingOperationsCount();

  @Query(
    'SELECT COUNT(*) FROM pending_operations WHERE entityType = :entityType',
  )
  Future<int?> getPendingOperationsCountByEntityType(String entityType);

  // --- Reactive (Stream) query ---

  @Query('SELECT * FROM pending_operations ORDER BY createdAt ASC')
  Stream<List<PendingOperationEntity>> watchAllPendingOperations();
}
