import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/presentation/screens/create_refuel/create_refuel_notifier.dart';
import 'package:fuelsense/presentation/screens/create_refuel/utils/meter_reading_validator.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRefuelNotifierProvider);
    final notifier = ref.read(createRefuelNotifierProvider.notifier);
    final lastOdometerAsync = ref.watch(
      lastOdometerReadingProvider(widget.userBikeId),
    );
    final lastOdometer = lastOdometerAsync.value;

    final label = widget.isFirstEntry
        ? 'Odometer Reading (km) *'
        : 'Odometer Reading (km)${state.tripMeterReading == null ? ' *' : ''}';

    return OutlinedTextField(
      controller: _controller,
      labelText: label,
      hintText: 'Enter odometer reading',
      prefixIcon: const Icon(Icons.directions_car_rounded),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: widget.enabled,
      onChanged: (value) {
        final parsed = double.tryParse(value);
        notifier.updateOdometerReading(parsed);
      },
      validator: (value) => MeterReadingValidator.validateOdometer(
        value: value,
        isFirstEntry: widget.isFirstEntry,
        currentTripMeter: state.tripMeterReading,
        lastOdometerReading: lastOdometer,
      ),
    );
  }
}
