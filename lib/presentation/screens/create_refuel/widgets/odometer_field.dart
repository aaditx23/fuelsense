import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/screens/create_refuel/utils/meter_reading_validator.dart';
import 'package:fuelsense/presentation/screens/create_refuel/utils/odometer_calculator.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

class OdometerField extends ConsumerStatefulWidget {
  final bool enabled;
  final bool isFirstEntry;
  final int userBikeId;

  const OdometerField({
    Key? key,
    this.enabled = true,
    this.isFirstEntry = false,
    required this.userBikeId,
  }) : super(key: key);

  @override
  ConsumerState<OdometerField> createState() => _OdometerFieldState();
}

class _OdometerFieldState extends ConsumerState<OdometerField> {
  late TextEditingController _controller;
  bool _isFocused = false;
  bool _isManual = false;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(createRefuelNotifierProvider).odometerReading;
    _controller = TextEditingController(
      text: existing != null ? existing.toString() : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _autoFill(double calculated, CreateRefuelNotifier notifier) {
    final formatted = calculated.toStringAsFixed(2);
    if (_controller.text != formatted) {
      _controller.text = formatted;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) notifier.updateCalculatedOdometer(calculated);
      });
    }
  }

  void _autoClear(CreateRefuelNotifier notifier) {
    if (_controller.text.isNotEmpty) {
      _controller.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) notifier.updateCalculatedOdometer(null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);
    final lastOdometer = ref
        .watch(lastOdometerReadingProvider(widget.userBikeId))
        .value;
    final lastTrip = ref
        .watch(lastTripMeterReadingProvider(widget.userBikeId))
        .value;

    ref.listen(createRefuelNotifierProvider, (prev, next) {
      if (_isFocused || _isManual) return;

      final currentTrip = next.tripMeterReading;

      if (currentTrip == null) {
        _autoClear(notifier);
        return;
      }

      final calculated = OdometerCalculator.calculateOdometer(
        lastOdometer: lastOdometer,
        lastTrip: lastTrip,
        currentTrip: currentTrip,
      );

      if (calculated != null) _autoFill(calculated, notifier);
    });

    final label = widget.isFirstEntry
        ? 'Odometer Reading (km) *'
        : 'Odometer Reading (km)${state.tripMeterReading == null ? ' *' : ''}';

    return Focus(
      onFocusChange: (focused) {
        _isFocused = focused;
        if (focused) _isManual = true;
      },
      child: OutlinedTextField(
        controller: _controller,
        labelText: label,
        hintText: lastOdometer != null
            ? 'Last: ${lastOdometer.toStringAsFixed(1)} km'
            : 'Enter odometer reading',
        prefixIcon: const Icon(Icons.directions_car_rounded),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        enabled: widget.enabled,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        onChanged: (value) {
          _isManual = true;
          if (value.trim().isEmpty) _isManual = false;
          notifier.updateOdometerReading(double.tryParse(value));
        },
        validator: (value) => MeterReadingValidator.validateOdometer(
          value: value,
          isFirstEntry: widget.isFirstEntry,
          currentTripMeter: state.tripMeterReading,
          lastOdometerReading: lastOdometer,
        ),
      ),
    );
  }
}
