import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;
  const MessageDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, "Close");
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}
