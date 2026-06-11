import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/fuel_amount_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/fuel_price_per_liter_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/fuel_total_cost_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/odometer_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/trip_meter_field.dart';

class RefuelTab extends ConsumerStatefulWidget {
  const RefuelTab({Key? key}) : super(key: key);

  @override
  ConsumerState<RefuelTab> createState() => _RefuelTabState();
}

class _RefuelTabState extends ConsumerState<RefuelTab> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRefuelNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isFirstEntryAsync = ref.watch(isFirstRefuelEntryProvider(1));

    final isFirstEntry = isFirstEntryAsync.value ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text(
          'Record a full refuel with trip meter, odometer readings, fuel amount, and price.',
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
        ),
        const SizedBox(height: 24),

        // Card 1: Meter Readings
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
                  enabled: !state.hasIncompleteEntry,
                  isRequired: isFirstEntry,
                ),
                const SizedBox(height: 16),
                OdometerField(
                  enabled: !state.hasIncompleteEntry,
                  isRequired: isFirstEntry,
                  userBikeId: 1,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Card 2: Fuel Details
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_gas_station,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fuel Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Price per liter — full width, mandatory
                const FuelPricePerLiterField(),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Enter either fuel amount or total cost — the other will be calculated automatically.',
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
                // Fuel amount + Total cost side by side
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: FuelAmountField()),
                    SizedBox(width: 12),
                    Expanded(child: FuelTotalCostField()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
