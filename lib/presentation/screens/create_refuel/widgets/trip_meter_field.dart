import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/screens/create_refuel/utils/meter_reading_validator.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

/// Blocks input above 999.99 and fires a callback so the UI can shake.
class _TripMeterInputFormatter extends TextInputFormatter {
  final VoidCallback onExceeded;

  _TripMeterInputFormatter({required this.onExceeded});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final parsed = double.tryParse(newValue.text);
    if (parsed == null) return oldValue;
    if (parsed > 999.99) {
      onExceeded();
      return oldValue;
    }
    return newValue;
  }
}

class TripMeterField extends ConsumerStatefulWidget {
  final bool enabled;
  final bool isFirstEntry;

  const TripMeterField({
    Key? key,
    this.enabled = true,
    this.isFirstEntry = false,
  }) : super(key: key);

  @override
  ConsumerState<TripMeterField> createState() => _TripMeterFieldState();
}

class _TripMeterFieldState extends ConsumerState<TripMeterField>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(createRefuelNotifierProvider).tripMeterReading;
    _controller = TextEditingController(
      text: existing != null ? existing.toString() : '',
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerExceeded() {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
    setState(() => _errorText = 'Trip meter cannot exceed 999.99 km');
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _errorText = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);

    final label = widget.isFirstEntry
        ? 'Trip Meter Reading (km) *'
        : 'Trip Meter Reading (km)${state.odometerReading == null ? ' *' : ''}';

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          _shakeController.isAnimating
              ? (_shakeAnimation.value *
                    ((_shakeController.value * 10).round().isEven ? 1 : -1))
              : 0,
          0,
        ),
        child: child,
      ),
      child: OutlinedTextField(
        controller: _controller,
        labelText: label,
        hintText: 'Enter trip meter reading',
        prefixIcon: const Icon(Icons.speed_rounded),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        enabled: widget.enabled,
        errorText: _errorText,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          _TripMeterInputFormatter(onExceeded: _triggerExceeded),
        ],
        onChanged: (value) {
          if (_errorText != null) setState(() => _errorText = null);
          final parsed = double.tryParse(value);
          notifier.updateTripMeterReading(parsed);
        },
        validator: (value) => MeterReadingValidator.validateTripMeter(
          value: value,
          isFirstEntry: widget.isFirstEntry,
          currentOdometer: state.odometerReading,
        ),
      ),
    );
  }
}
