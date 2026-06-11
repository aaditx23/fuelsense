import 'dart:async';
import 'package:fuelsense/data/datasources/local/dao/pending_operation_dao.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'operation_handler.dart';
import 'connectivity_service.dart';
import '../datasources/local/entity/pending_operation_entity.dart';

class SyncManager {
  final PendingOperationDao _pendingOperationDao;
  final ConnectivityService _connectivityService;
  final AppSharedPreferences _prefs;

  final Map<String, OperationHandler> _handlers = {};
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isSyncing = false;

  SyncManager(
    this._pendingOperationDao,
    this._connectivityService,
    this._prefs,
  );

  void registerHandler(String operationType, OperationHandler handler) {
    _handlers[operationType] = handler;
  }

  void init() {
    _connectivitySubscription = _connectivityService.onConnectivityChanged
        .listen((isConnected) {
          if (isConnected) {
            processPendingOperations();
          }
        });
  }

  /// Processes all pending operations. Safe to call multiple times —
  /// concurrent calls are ignored while a sync is already in progress.
  Future<void> processPendingOperations() async {
    if (_isSyncing) {
      print('[SyncManager] Sync already in progress, skipping');
      return;
    }
    _isSyncing = true;
    print('[SyncManager] Starting sync process');

    try {
      final pendingOperations = await _pendingOperationDao
          .getAllPendingOperations();
      print(
        '[SyncManager] Found ${pendingOperations.length} pending operations',
      );

      for (final operation in pendingOperations) {
        print(
          '[SyncManager] Processing operation ${operation.id}: ${operation.operationType} (${operation.entityType})',
        );

        final handler = _handlers[operation.operationType];
        if (handler == null) {
          print(
            '[SyncManager] ERROR: No handler registered for ${operation.operationType}',
          );
          await _pendingOperationDao.updateOperation(
            operation.copyWith(
              retryCount: operation.retryCount + 1,
              lastError: 'Unknown operation type: ${operation.operationType}',
            ),
          );
          continue;
        }

        try {
          await handler.execute(operation);
          print(
            '[SyncManager] Operation ${operation.id} executed successfully, deleting from queue',
          );
          await _pendingOperationDao.deleteOperationById(operation.id!);
        } catch (e) {
          print('[SyncManager] ERROR: Operation ${operation.id} failed: $e');
          await _pendingOperationDao.updateOperation(
            operation.copyWith(
              retryCount: operation.retryCount + 1,
              lastError: e.toString(),
            ),
          );
        }
      }
      print('[SyncManager] Sync process completed');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> enqueueOperation(PendingOperationEntity operation) async {
    await _pendingOperationDao.insertOperation(operation);

    // Attempt immediate sync if connected
    if (await _connectivityService.isConnected()) {
      processPendingOperations();
    }
  }

  Future<int> getPendingOperationsCount() async {
    return await _pendingOperationDao.getPendingOperationsCount() ?? 0;
  }

  Future<int> getPendingOperationsCountByEntityType(String entityType) async {
    return await _pendingOperationDao.getPendingOperationsCountByEntityType(
          entityType,
        ) ??
        0;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
