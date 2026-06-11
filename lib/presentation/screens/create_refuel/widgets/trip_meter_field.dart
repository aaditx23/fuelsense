import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

class TripMeterInputFormatter extends TextInputFormatter {
  final VoidCallback? onInvalidInput;

  TripMeterInputFormatter({this.onInvalidInput});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final parsed = double.tryParse(newValue.text);
    if (parsed == null) {
      onInvalidInput?.call();
      return oldValue;
    }

    if (parsed > 999.99) {
      onInvalidInput?.call();
      return oldValue;
    }

    return newValue;
  }
}

class TripMeterField extends ConsumerStatefulWidget {
  final bool enabled;
  final bool isRequired;

  const TripMeterField({Key? key, this.enabled = true, this.isRequired = false})
    : super(key: key);

  @override
  ConsumerState<TripMeterField> createState() => _TripMeterFieldState();
}

class _TripMeterFieldState extends ConsumerState<TripMeterField> {
  String? _errorText;

  void _showError() {
    if (mounted) {
      setState(() {
        _errorText = 'Trip meter cannot exceed 999.99 km';
      });
      // Clear error after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _errorText = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);

    return OutlinedTextField(
      initialValue: state.tripMeterReading?.toString() ?? '',
      labelText: widget.isRequired
          ? 'Trip Meter Reading (km)'
          : 'Trip Meter Reading (km) - Optional',
      hintText: 'Enter trip meter reading',
      prefixIcon: const Icon(Icons.speed_rounded),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: widget.enabled,
      errorText: _errorText,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        TripMeterInputFormatter(onInvalidInput: _showError),
      ],
      onChanged: (value) {
        // Clear error on valid input
        if (_errorText != null) {
          setState(() {
            _errorText = null;
          });
        }
        final parsed = double.tryParse(value);
        notifier.updateTripMeterReading(parsed);
      },
      validator: (value) {
        if (widget.isRequired &&
            (value == null || value.isEmpty) &&
            state.odometerReading == null) {
          return 'At least one reading is required';
        }
        if (value != null && value.isNotEmpty) {
          final parsed = double.tryParse(value);
          if (parsed == null) {
            return 'Please enter a valid number';
          }
          if (parsed > 999.99) {
            return 'Trip meter cannot exceed 999.99 km';
          }
        }
        return null;
      },
    );
  }
}
