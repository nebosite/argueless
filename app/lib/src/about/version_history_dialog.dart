import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

/// Every version, newest first, with what changed in each.
class VersionHistoryDialog extends StatelessWidget {
  const VersionHistoryDialog({super.key, required this.changelog});

  final Changelog changelog;

  static Future<void> show(BuildContext context, Changelog changelog) =>
      showDialog<void>(
        context: context,
        builder: (_) => VersionHistoryDialog(changelog: changelog),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('What changed'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final note in changelog.notes) ...[
              Text(
                '${note.version}  ·  ${note.date}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              for (final change in note.changes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('•  $change'),
                ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
