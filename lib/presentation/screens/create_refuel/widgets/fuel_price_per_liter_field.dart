import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

class FuelPricePerLiterField extends ConsumerStatefulWidget {
  const FuelPricePerLiterField({Key? key}) : super(key: key);

  @override
  ConsumerState<FuelPricePerLiterField> createState() =>
      _FuelPricePerLiterFieldState();
}

class _FuelPricePerLiterFieldState
    extends ConsumerState<FuelPricePerLiterField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(createRefuelNotifierProvider).fuelPricePerLiter;
    _controller = TextEditingController(
      text: existing != null ? existing.toString() : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      controller: _controller,
      labelText: 'Price per Liter (৳) *',
      hintText: 'Enter price per liter',
      prefixIcon: const Icon(Icons.attach_money_rounded),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final parsed = double.tryParse(value);
        ref
            .read(createRefuelNotifierProvider.notifier)
            .updateFuelPricePerLiter(parsed);
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Price per liter is required';
        }
        final parsed = double.tryParse(value);
        if (parsed == null) {
          return 'Please enter a valid number';
        }
        if (parsed <= 0) {
          return 'Price must be greater than 0';
        }
        return null;
      },
    );
  }
}
