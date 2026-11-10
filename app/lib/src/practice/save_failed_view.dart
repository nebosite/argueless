import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';

/// Shown when a finished practice could not be saved: the practice is kept
/// in memory and the user can try again.
class SaveFailedView extends StatelessWidget {
  const SaveFailedView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(ArguelessTheme.gutter),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.save_outlined, size: 48),
          const SizedBox(height: 12),
          Text(
            "Your practice couldn't be saved",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'It is still here. Check that the phone has free space, then '
            'try again.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
