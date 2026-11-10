import 'package:flutter/material.dart';

/// Asks before leaving a practice that has ideas in it.
class LeavePracticeDialog extends StatelessWidget {
  const LeavePracticeDialog({super.key});

  /// True if the user chose to leave.
  static Future<bool> show(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => const LeavePracticeDialog(),
      ) ??
      false;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Leave this practice?'),
    content: const Text(
      "Your ideas so far won't be saved. You can come back to this "
      'scenario another day.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Keep going'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Leave'),
      ),
    ],
  );
}
