class PendingOperationEntity {
  final int? id;
  final String entityType; // "bike", "refuel", "user", etc.
  final String operationType; // "selectBike", "createRefuel", etc.
  final int? entityId; // remoteId of the entity (null for create)
  final int? localEntityId; // localId of the entity (for create, before remoteId exists)
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

  factory PendingOperationEntity.fromJson(Map<String, dynamic> json, [int? localKey]) {
    return PendingOperationEntity(
      id: localKey ?? json['id'] as int?,
      entityType: json['entityType'] as String,
      operationType: json['operationType'] as String,
      entityId: json['entityId'] as int?,
      localEntityId: json['localEntityId'] as int?,
      payload: json['payload'] as String?,
      createdAt: json['createdAt'] as String,
      retryCount: json['retryCount'] as int? ?? 0,
      lastError: json['lastError'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entityType': entityType,
      'operationType': operationType,
      'entityId': entityId,
      'localEntityId': localEntityId,
      'payload': payload,
      'createdAt': createdAt,
      'retryCount': retryCount,
      'lastError': lastError,
    };
  }

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
