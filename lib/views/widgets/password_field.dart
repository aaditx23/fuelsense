import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? Function(String?)? validator;

  const PasswordField({
    Key? key,
    required this.controller,
    this.labelText,
    this.validator,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  void _toggleObscure() {
    setState(() => _obscure = !_obscure);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: widget.labelText ?? 'Password',
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: _toggleObscure,
        ),
      ),
      validator: widget.validator,
    );
  }
}
