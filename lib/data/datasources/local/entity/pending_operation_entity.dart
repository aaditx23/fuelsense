import 'package:floor/floor.dart';

@Entity(tableName: "pending_operations")
class PendingOperationEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String entityType; // "bike", "refuel", "user", etc.
  final String operationType; // "selectBike", "createRefuel", etc.
  final int? entityId; // remoteId of the entity (null for create)
  final int?
  localEntityId; // localId of the entity (for create, before remoteId exists)
  final String? payload; // JSON string - any data the operation needs
  final String createdAt; // ISO 8601 timestamp
  final int retryCount; // number of failed attempts
  final String? lastError; // last error message from failed sync attempt

  PendingOperationEntity({
    this.id,
    required this.entityType,
    required this.operationType,
    this.entityId,
    this.localEntityId,
    this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.lastError,
  });

  PendingOperationEntity copyWith({
    int? id,
    String? entityType,
    String? operationType,
    int? entityId,
    int? localEntityId,
    String? payload,
    String? createdAt,
    int? retryCount,
    String? lastError,
  }) {
    return PendingOperationEntity(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      operationType: operationType ?? this.operationType,
      entityId: entityId ?? this.entityId,
      localEntityId: localEntityId ?? this.localEntityId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }
}
