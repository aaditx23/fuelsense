import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/trip_meter_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/odometer_field.dart';

class ReserveHitTab extends ConsumerWidget {
  final bool isIncomplete;

  const ReserveHitTab({Key? key, this.isIncomplete = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFirstEntryAsync = ref.watch(isFirstRefuelEntryProvider(1));

    final isFirstEntry = isFirstEntryAsync.value ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          'Record when your bike hits reserve. This helps track fuel efficiency between reserve cycles.',
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
        ),
        const SizedBox(height: 24),

        // Card: Meter Readings
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.speed, size: 20, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Meter Readings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (isFirstEntry)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'First entry: Both readings are required',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Either trip meter or odometer is required',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                TripMeterField(
                  enabled: !isIncomplete,
                  isRequired: isFirstEntry,
                ),
                const SizedBox(height: 16),
                OdometerField(
                  enabled: !isIncomplete,
                  isRequired: isFirstEntry,
                  userBikeId: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
