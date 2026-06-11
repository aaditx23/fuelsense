import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/domain/entities/refuel.dart';
import 'package:fuelsense/presentation/screens/refuel_dashboard/refuel_dashboard_notifier.dart';
import 'package:intl/intl.dart';

class RecentRefuelsCard extends ConsumerWidget {
  const RecentRefuelsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get actual user bike ID
    const userBikeId = 1;
    final refuelsAsync = ref.watch(refuelStreamProvider(userBikeId));

    return refuelsAsync.when(
      data: (allRefuels) {
        final recentRefuels = allRefuels.take(3).toList();

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Refuels',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/refuel_list');
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('See More'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (recentRefuels.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_gas_station_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No refuel entries yet',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...recentRefuels.map(
                    (refuel) => _buildRefuelItem(context, refuel),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Error loading recent refuels',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefuelItem(BuildContext context, Refuel refuel) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getEntryTypeColor(
                refuel.entryType,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getEntryTypeIcon(refuel.entryType),
              color: _getEntryTypeColor(refuel.entryType),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getEntryTypeLabel(refuel.entryType),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${dateFormat.format(refuel.createdAt)} at ${timeFormat.format(refuel.createdAt)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (refuel.fuelLiter != null)
                Text(
                  '${refuel.fuelLiter}L',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              if (refuel.tripMeterReading != null)
                Text(
                  '${refuel.tripMeterReading} km',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getEntryTypeColor(RefuelEntryType type) {
    switch (type) {
      case RefuelEntryType.reserveIncomplete:
        return Colors.orange;
      case RefuelEntryType.reserveComplete:
        return Colors.green;
      case RefuelEntryType.topup:
        return Colors.blue;
    }
  }

  IconData _getEntryTypeIcon(RefuelEntryType type) {
    switch (type) {
      case RefuelEntryType.reserveIncomplete:
        return Icons.warning;
      case RefuelEntryType.reserveComplete:
        return Icons.local_gas_station;
      case RefuelEntryType.topup:
        return Icons.add;
    }
  }

  String _getEntryTypeLabel(RefuelEntryType type) {
    switch (type) {
      case RefuelEntryType.reserveIncomplete:
        return 'Reserve Hit';
      case RefuelEntryType.reserveComplete:
        return 'Refueled';
      case RefuelEntryType.topup:
        return 'Top-up';
    }
  }
}
