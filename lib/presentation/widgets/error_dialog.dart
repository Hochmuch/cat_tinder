import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, Object error) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Ошибка'),
        content: Text(error.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
