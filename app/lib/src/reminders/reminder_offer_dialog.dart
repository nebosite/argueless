import 'package:flutter/material.dart';

/// Offered once, after the first practice: would a daily nudge help? Asked
/// in the app's own words before the phone asks for permission.
class ReminderOfferDialog extends StatelessWidget {
  const ReminderOfferDialog({super.key});

  /// True if the user would like reminders, false if not, null if they
  /// left without answering (offered again after another practice).
  static Future<bool?> show(BuildContext context) => showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const ReminderOfferDialog(),
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    icon: const Icon(Icons.notifications_active_rounded),
    title: const Text('A gentle daily nudge?'),
    content: const Text(
      'Some people like a small nudge. ArgueLess can remind you once a '
      'day, at 7 pm, and not on days you have already practised. Not for '
      'you? No problem: you can turn reminders on or off any time in '
      'Settings.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('No thanks'),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Yes, remind me'),
      ),
    ],
  );
}
