import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String labelText;
  final IconData prefixIcon;
  const DropdownWidget({
    super.key,
    required this.items,
    required this.onChanged,
    required this.labelText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: items.map((String item) {
        return DropdownMenuItem(value: item, child: Text(item.toUpperCase()));
      }).toList(),
      onChanged: (value) => onChanged(value),
      initialValue: items[0],
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
