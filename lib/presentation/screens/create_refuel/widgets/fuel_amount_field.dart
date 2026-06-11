import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

class FuelAmountField extends ConsumerStatefulWidget {
  const FuelAmountField({Key? key}) : super(key: key);

  @override
  ConsumerState<FuelAmountField> createState() => _FuelAmountFieldState();
}

class _FuelAmountFieldState extends ConsumerState<FuelAmountField> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(createRefuelNotifierProvider).fuelLiter;
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
    // Reactively update this field when total cost changes (if not focused)
    ref.listen(createRefuelNotifierProvider, (prev, next) {
      if (_isFocused) return;
      final pricePerLiter = next.fuelPricePerLiter;
      final totalCost = next.fuelPrice;
      if (pricePerLiter != null && pricePerLiter > 0 && totalCost != null) {
        final calculated = (totalCost / pricePerLiter);
        final formatted = calculated.toStringAsFixed(2);
        if (_controller.text != formatted) {
          _controller.text = formatted;
          // Update state without triggering a loop
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(createRefuelNotifierProvider.notifier)
                  .updateFuelLiter(calculated);
            }
          });
        }
      }
    });

    return Focus(
      onFocusChange: (focused) => _isFocused = focused,
      child: OutlinedTextField(
        controller: _controller,
        labelText: 'Fuel Amount (L)',
        hintText: 'Enter liters',
        labelStyle: const TextStyle(fontSize: 12),
        hintStyle: const TextStyle(fontSize: 12),
        prefixIcon: const Icon(Icons.local_gas_station_rounded),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          // Empty field is treated as 0
          final parsed = value.trim().isEmpty ? 0.0 : double.tryParse(value);
          final notifier = ref.read(createRefuelNotifierProvider.notifier);
          notifier.updateFuelLiter(parsed ?? 0.0);

          // Auto-calculate total cost
          final pricePerLiter = ref
              .read(createRefuelNotifierProvider)
              .fuelPricePerLiter;
          if (pricePerLiter != null) {
            notifier.updateFuelPrice((parsed ?? 0.0) * pricePerLiter);
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
          final totalCost = state.fuelPrice ?? 0.0;
          if (parsed == 0.0 && totalCost == 0.0) {
            return 'Enter liters or total cost';
          }
          return null;
        },
      ),
    );
  }
}
