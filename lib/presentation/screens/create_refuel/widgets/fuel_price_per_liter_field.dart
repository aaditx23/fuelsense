import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

class FuelPricePerLiterField extends ConsumerStatefulWidget {
  final Function(double?) onPricePerLiterChanged;
  final bool isRequired;

  const FuelPricePerLiterField({
    Key? key,
    required this.onPricePerLiterChanged,
    this.isRequired = false,
  }) : super(key: key);

  @override
  ConsumerState<FuelPricePerLiterField> createState() =>
      _FuelPricePerLiterFieldState();
}

class _FuelPricePerLiterFieldState
    extends ConsumerState<FuelPricePerLiterField> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRefuelNotifierProvider);

    // Calculate price per liter if both total and liters are available
    if (state.fuelPrice != null &&
        state.fuelLiter != null &&
        state.fuelLiter! > 0) {
      final calculated = (state.fuelPrice! / state.fuelLiter!).toStringAsFixed(
        2,
      );
      if (_controller.text != calculated) {
        _controller.text = calculated;
      }
    }

    // Revalidate when isRequired changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });

    return OutlinedTextField(
      key: _formKey,
      controller: _controller,
      labelText: 'Price per Liter (৳)',
      hintText: 'Enter price per liter',
      prefixIcon: const Icon(Icons.attach_money_rounded),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final parsed = double.tryParse(value);
        widget.onPricePerLiterChanged(parsed);
      },
      validator: (value) {
        // Check if required
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        // Optional field - no validation required
        if (value != null && value.isNotEmpty) {
          final parsed = double.tryParse(value);
          if (parsed == null) {
            return 'Please enter a valid number';
          }
          if (parsed <= 0) {
            return 'Price must be greater than 0';
          }
        }
        return null;
      },
    );
  }
}
