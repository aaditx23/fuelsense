import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

class OdometerField extends ConsumerWidget {
  final bool enabled;
  final bool isRequired;
  final int userBikeId;

  const OdometerField({
    Key? key,
    this.enabled = true,
    this.isRequired = false,
    required this.userBikeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);
    final lastOdometerAsync = ref.watch(
      lastOdometerReadingProvider(userBikeId),
    );

    return OutlinedTextField(
      initialValue: state.odometerReading?.toString() ?? '',
      labelText: isRequired
          ? 'Odometer Reading (km)'
          : 'Odometer Reading (km) - Optional',
      hintText: 'Enter odometer reading',
      prefixIcon: const Icon(Icons.directions_car_rounded),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: enabled,
      onChanged: (value) {
        final parsed = double.tryParse(value);
        notifier.updateOdometerReading(parsed);
      },
      validator: (value) {
        if (isRequired &&
            (value == null || value.isEmpty) &&
            state.tripMeterReading == null) {
          return 'At least one reading is required';
        }
        if (value != null && value.isNotEmpty) {
          final parsed = double.tryParse(value);
          if (parsed == null) {
            return 'Please enter a valid number';
          }

          // Validate against last odometer reading
          final lastOdometer = lastOdometerAsync.value;
          if (lastOdometer != null && parsed < lastOdometer) {
            return 'Cannot be less than last reading (${lastOdometer.toStringAsFixed(1)} km)';
          }
        }
        return null;
      },
    );
  }
}
