import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/trip_meter_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/odometer_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/fuel_amount_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/fuel_price_per_liter_field.dart';
import 'package:fuelsense/presentation/screens/create_refuel/widgets/fuel_total_cost_field.dart';

class TopupTab extends ConsumerStatefulWidget {
  const TopupTab({Key? key}) : super(key: key);

  @override
  ConsumerState<TopupTab> createState() => _TopupTabState();
}

class _TopupTabState extends ConsumerState<TopupTab> {
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
          'Add fuel before hitting reserve to extend your range. Top-ups don\'t close your current cycle.',
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
                TripMeterField(isRequired: isFirstEntry),
                const SizedBox(height: 16),
                OdometerField(isRequired: isFirstEntry, userBikeId: 1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Card 2: Fuel Details (Liters + Price per Liter)
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
                const FuelAmountField(),
                const SizedBox(height: 16),
                FuelPricePerLiterField(
                  isRequired: state.fuelLiter != null,
                  onPricePerLiterChanged: (pricePerLiter) {
                    // Auto-calculate total if both liters and per-liter price are available
                    if (pricePerLiter != null && state.fuelLiter != null) {
                      final total = state.fuelLiter! * pricePerLiter;
                      ref
                          .read(createRefuelNotifierProvider.notifier)
                          .updateFuelPrice(total);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Card 3: Total Cost (Direct Input)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total Cost',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
                          'Enter total cost directly if you don\'t know liters or per-liter price',
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
                const FuelTotalCostField(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
