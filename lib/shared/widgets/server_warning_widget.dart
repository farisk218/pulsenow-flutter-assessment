import 'package:flutter/material.dart';
import '../../utils/strings.dart';

/// Reusable server down warning widget
///
/// Displays a consistent server warning UI across all screens when
/// there's a connection error or server is down.
class ServerWarningWidget extends StatelessWidget {
  /// Callback function called when the retry button is pressed
  final VoidCallback onRetry;

  const ServerWarningWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/server_warning.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.connectionError,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.serverDownMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
