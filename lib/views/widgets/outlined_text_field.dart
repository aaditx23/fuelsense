import 'package:flutter/material.dart';

class OutlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const OutlinedTextField({
    Key? key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.enabled = true,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLength: maxLength,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
