import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

class FuelTotalCostField extends ConsumerWidget {
  const FuelTotalCostField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);

    return OutlinedTextField(
      initialValue: state.fuelPrice?.toString() ?? '',
      labelText: 'Total Cost (৳)',
      hintText: 'Enter total fuel cost',
      prefixIcon: const Icon(Icons.receipt_long),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final parsed = double.tryParse(value);
        notifier.updateFuelPrice(parsed);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        final parsed = double.tryParse(value);
        if (parsed == null) {
          return 'Please enter a valid number';
        }
        if (parsed <= 0) {
          return 'Total cost must be greater than 0';
        }
        return null;
      },
    );
  }
}
