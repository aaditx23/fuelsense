
import 'package:flutter/material.dart';

class ResponseText extends StatelessWidget {
  final bool success;
  final String message;
  const ResponseText({super.key, required this.success, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        message,
        style: TextStyle(
          color: success ? Colors.lightGreen : Colors.red,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
