import 'package:flutter/material.dart';
import 'package:fuelsense/views/widgets/outlined_text_field.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search...',
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: OutlinedTextField(
        labelText: "Search Bikes",
        controller: controller,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
            onChanged('');
          },
          icon: const Icon(Icons.backspace),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
