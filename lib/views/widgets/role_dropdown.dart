import 'package:flutter/material.dart';

class RoleDropdown extends StatelessWidget {
  final String value;
  final void Function(String?) onChanged;
  final List<String> roles;

  const RoleDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
    this.roles = const ['user', 'admin'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Role',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
        ), // Makes it look like an OutlinedTextField
      ),
      items: roles.map((role) => DropdownMenuItem(
        value: role,
        child: Text(role),
      )).toList(),
      onChanged: onChanged,
    );
  }
}
