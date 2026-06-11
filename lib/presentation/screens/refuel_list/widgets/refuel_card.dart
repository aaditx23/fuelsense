import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/domain/entities/refuel.dart';
import 'package:fuelsense/presentation/screens/refuel_list/widgets/refuel_entry_type_helper.dart';
import 'package:fuelsense/presentation/screens/refuel_list/widgets/refuel_info_item.dart';
import 'package:fuelsense/presentation/screens/refuel_list/refuel_list_notifier.dart';
import 'package:intl/intl.dart';

class RefuelCard extends ConsumerWidget {
  final Refuel refuel;

  const RefuelCard({Key? key, required this.refuel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: RefuelEntryTypeHelper.getEntryTypeColor(
                      refuel.entryType,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    RefuelEntryTypeHelper.getEntryTypeIcon(refuel.entryType),
                    color: RefuelEntryTypeHelper.getEntryTypeColor(
                      refuel.entryType,
                    ),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        RefuelEntryTypeHelper.getEntryTypeLabel(
                          refuel.entryType,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${dateFormat.format(refuel.createdAt)} at ${timeFormat.format(refuel.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red.shade400,
                  onPressed: () => _showDeleteConfirmation(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (refuel.tripMeterReading != null) ...[
                  Expanded(
                    child: RefuelInfoItem(
                      label: 'Trip Meter',
                      value: '${refuel.tripMeterReading} km',
                      icon: Icons.speed,
                    ),
                  ),
                ],
                if (refuel.odometerReading != null) ...[
                  Expanded(
                    child: RefuelInfoItem(
                      label: 'Odometer',
                      value: '${refuel.odometerReading} km',
                      icon: Icons.directions_car,
                    ),
                  ),
                ],
                if (refuel.fuelLiter != null) ...[
                  Expanded(
                    child: RefuelInfoItem(
                      label: 'Fuel',
                      value: '${refuel.fuelLiter}L',
                      icon: Icons.local_gas_station,
                    ),
                  ),
                ],
                if (refuel.fuelPrice != null && refuel.fuelLiter != null) ...[
                  Expanded(
                    child: RefuelInfoItem(
                      label: 'Cost',
                      value:
                          '৳${(refuel.fuelPrice! * refuel.fuelLiter!).toStringAsFixed(0)}',
                      icon: Icons.currency_rupee,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text(
          'Are you sure you want to delete this refuel entry? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final deleteUseCase = ref.read(deleteRefuelUseCaseProvider);
              try {
                await deleteUseCase.execute(refuel);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Entry deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
