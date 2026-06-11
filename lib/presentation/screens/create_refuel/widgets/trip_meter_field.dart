import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/screens/create_refuel/utils/meter_reading_validator.dart';
import 'package:fuelsense/presentation/widgets/outlined_text_field.dart';

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

class _TripMeterFieldState extends ConsumerState<TripMeterField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final existing = ref.read(createRefuelNotifierProvider).tripMeterReading;
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
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);

    final label = widget.isFirstEntry
        ? 'Trip Meter Reading (km) *'
        : 'Trip Meter Reading (km)${state.odometerReading == null ? ' *' : ''}';

    return OutlinedTextField(
      controller: _controller,
      labelText: label,
      hintText: 'Enter trip meter reading',
      prefixIcon: const Icon(Icons.speed_rounded),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: widget.enabled,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      onChanged: (value) {
        final parsed = double.tryParse(value);
        notifier.updateTripMeterReading(parsed);
      },
      validator: (value) => MeterReadingValidator.validateTripMeter(
        value: value,
        isFirstEntry: widget.isFirstEntry,
        currentOdometer: state.odometerReading,
      ),
    );
  }
}
