import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/di/setup_di.dart';
import 'package:fuelsense/data/services/sync_manager.dart';
import 'package:fuelsense/data/services/connectivity_service.dart';
import 'package:fuelsense/data/datasources/local/dao/pending_operation_dao.dart';
import 'package:fuelsense/presentation/widgets/common_scaffold.dart';
import 'pending_operations_provider.dart';

class PendingOperationsScreen extends ConsumerStatefulWidget {
  const PendingOperationsScreen({super.key});

  @override
  ConsumerState<PendingOperationsScreen> createState() =>
      _PendingOperationsScreenState();
}

class _PendingOperationsScreenState
    extends ConsumerState<PendingOperationsScreen> {
  late final SyncManager _syncManager;
  late final ConnectivityService _connectivityService;
  late final PendingOperationDao _pendingOperationDao;
  StreamSubscription<bool>? _connectivitySubscription;

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _syncManager = getIt<SyncManager>();
    _connectivityService = getIt<ConnectivityService>();
    _pendingOperationDao = getIt<PendingOperationDao>();

    _connectivitySubscription = _connectivityService.onConnectivityChanged
        .listen((isConnected) {
          if (mounted) {
            setState(() => _isConnected = isConnected);
          }
        });
    _connectivityService.isConnected().then((isConnected) {
      if (mounted) {
        setState(() => _isConnected = isConnected);
      }
    });
  }

  Future<void> _triggerSync() async {
    await _syncManager.processPendingOperations();
    // No need to manually reload — the StreamProvider updates the UI automatically
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the reactive stream — UI rebuilds automatically on any DB change
    final pendingOpsAsync = ref.watch(pendingOperationsStreamProvider);

    return CommonScaffold(
      title: 'Pending Operations Queue',
      showDrawer: true,
      actions: [],
      fab: FloatingActionButton(
        onPressed: _triggerSync,
        child: const Icon(Icons.sync),
        tooltip: 'Sync Now',
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: _isConnected ? Colors.green.shade100 : Colors.red.shade100,
            child: Row(
              children: [
                Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: _isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _triggerSync,
                  child: const Text('Sync Now'),
                ),
              ],
            ),
          ),

          // Queue Count — auto-updates from stream
          pendingOpsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: $e'),
            ),
            data: (ops) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Pending Operations: ${ops.length}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          // Operations List — auto-updates when queue changes
          Expanded(
            child: pendingOpsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (pendingOperations) => pendingOperations.isEmpty
                  ? const Center(child: Text('No pending operations'))
                  : ListView.builder(
                      itemCount: pendingOperations.length,
                      itemBuilder: (context, index) {
                        final operation = pendingOperations[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${operation.operationType} (${operation.entityType})',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (operation.lastError != null)
                                  const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Entity ID: ${operation.entityId ?? 'N/A'}'),
                                Text(
                                  'Local Entity ID: ${operation.localEntityId ?? 'N/A'}',
                                ),
                                Text('Created: ${operation.createdAt}'),
                                Text('Retry Count: ${operation.retryCount}'),
                                if (operation.payload != null)
                                  Text(
                                    'Payload: ${operation.payload!.length > 50 ? '${operation.payload!.substring(0, 50)}...' : operation.payload}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                if (operation.lastError != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.red.shade200,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Last Error:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          operation.lastError!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // DB write → stream emits → UI updates automatically
                                await _pendingOperationDao.deleteOperationById(
                                  operation.id!,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
