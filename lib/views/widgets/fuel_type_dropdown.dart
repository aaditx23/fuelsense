import 'package:flutter/material.dart';

class FuelTypeDropdown extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String?> onChanged;
  final List<String> fuelTypes;

  const FuelTypeDropdown({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    this.fuelTypes = const ['Petrol', 'Octane'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: 'Fuel Type',
        prefixIcon: const Icon(Icons.local_gas_station),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: fuelTypes.map((String type) {
        return DropdownMenuItem<String>(value: type, child: Text(type));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
