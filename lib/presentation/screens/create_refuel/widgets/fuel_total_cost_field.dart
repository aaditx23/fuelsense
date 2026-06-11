import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

class FuelTotalCostField extends ConsumerStatefulWidget {
  const FuelTotalCostField({Key? key}) : super(key: key);

  @override
  ConsumerState<FuelTotalCostField> createState() => _FuelTotalCostFieldState();
}

class _FuelTotalCostFieldState extends ConsumerState<FuelTotalCostField> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(createRefuelNotifierProvider).fuelPrice;
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
    // Reactively update when fuelLiter changes (if not focused)
    ref.listen(createRefuelNotifierProvider, (prev, next) {
      if (_isFocused) return;
      final pricePerLiter = next.fuelPricePerLiter;
      final liters = next.fuelLiter;
      if (pricePerLiter != null && liters != null) {
        final calculated = liters * pricePerLiter;
        final formatted = calculated.toStringAsFixed(2);
        if (_controller.text != formatted) {
          _controller.text = formatted;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(createRefuelNotifierProvider.notifier)
                  .updateFuelPrice(calculated);
            }
          });
        }
      }
    });

    return Focus(
      onFocusChange: (focused) => _isFocused = focused,
      child: OutlinedTextField(
        controller: _controller,
        labelText: 'Cost (৳)',
        hintText: 'Enter total cost',
        hintStyle: const TextStyle(fontSize: 11),
        prefixIcon: const Icon(Icons.receipt_long),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          // Empty field is treated as 0
          final parsed = value.trim().isEmpty ? 0.0 : double.tryParse(value);
          final notifier = ref.read(createRefuelNotifierProvider.notifier);
          notifier.updateFuelPrice(parsed ?? 0.0);

          // Auto-calculate fuel liters
          final pricePerLiter = ref
              .read(createRefuelNotifierProvider)
              .fuelPricePerLiter;
          if (pricePerLiter != null && pricePerLiter > 0) {
            notifier.updateFuelLiter((parsed ?? 0.0) / pricePerLiter);
          }
        },
        validator: (value) {
          final parsed = value == null || value.trim().isEmpty
              ? 0.0
              : double.tryParse(value);
          if (parsed == null) return 'Please enter a valid number';
          if (parsed < 0) return 'Must be 0 or greater';
          // Both fields cannot be 0
          final state = ref.read(createRefuelNotifierProvider);
          final liters = state.fuelLiter ?? 0.0;
          if (parsed == 0.0 && liters == 0.0) {
            return 'Enter total cost or liters';
          }
          return null;
        },
      ),
    );
  }
}
