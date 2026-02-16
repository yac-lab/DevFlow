import 'package:flutter/material.dart';

class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_off, size: 64, color: Colors.red.shade200),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center),
        ElevatedButton(onPressed: onRetry, child: const Text('Reessayer')),
      ],
    ),
  );
}
