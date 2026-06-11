import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

class FuelPriceField extends ConsumerWidget {
  const FuelPriceField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);

    return OutlinedTextField(
      initialValue: state.fuelPrice?.toString() ?? '',
      labelText: 'Fuel Price per Liter',
      hintText: 'Enter fuel price per liter',
      prefixIcon: const Icon(Icons.attach_money_rounded),
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
          return 'Fuel price must be greater than 0';
        }
        return null;
      },
    );
  }
}
