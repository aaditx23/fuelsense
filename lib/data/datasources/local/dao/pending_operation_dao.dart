import 'package:hive/hive.dart';
import 'package:fuelsense/data/datasources/local/entity/pending_operation_entity.dart';

class PendingOperationDao {
  final Box _box;

  PendingOperationDao(this._box);

  Future<int> insertOperation(PendingOperationEntity operation) async {
    final key = await _box.add(operation.toJson());
    // Assign local key to operation if needed, but since operation is final in its fields, 
    // we make a copy with local id to save
    final savedOp = operation.copyWith(id: key);
    await _box.put(key, savedOp.toJson());
    return key;
  }

  Future<void> insertOperations(List<PendingOperationEntity> operations) async {
    for (final op in operations) {
      await insertOperation(op);
    }
  }

  Future<List<PendingOperationEntity>> getAllPendingOperations() async {
    final list = _box.keys.map((key) {
      final value = _box.get(key);
      return PendingOperationEntity.fromJson(Map<String, dynamic>.from(value as Map), key as int);
    }).toList();
    return list..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<PendingOperationEntity?> getOperationById(int id) async {
    final value = _box.get(id);
    if (value == null) return null;
    return PendingOperationEntity.fromJson(Map<String, dynamic>.from(value as Map), id);
  }

  Future<int> deleteOperation(PendingOperationEntity operation) async {
    if (operation.id != null) {
      await _box.delete(operation.id);
      return 1;
    }
    return 0;
  }

  Future<void> deleteOperationById(int id) async {
    await _box.delete(id);
  }

  Future<void> deleteAllOperations() async {
    await _box.clear();
  }

  Future<int> updateOperation(PendingOperationEntity operation) async {
    if (operation.id != null) {
      await _box.put(operation.id, operation.toJson());
      return 1;
    }
    return 0;
  }

  Future<int?> getPendingOperationsCount() async {
    return _box.length;
  }

  Future<int?> getPendingOperationsCountByEntityType(String entityType) async {
    final list = await getAllPendingOperations();
    return list.where((op) => op.entityType == entityType).length;
  }

  Stream<List<PendingOperationEntity>> watchAllPendingOperations() {
    return _box.watch().map((_) {
      final list = _box.keys.map((key) {
        final value = _box.get(key);
        return PendingOperationEntity.fromJson(Map<String, dynamic>.from(value as Map), key as int);
      }).toList();
      return list..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    });
  }
}
