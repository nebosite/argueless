import 'package:flutter/material.dart';

import '../app/app_services.dart';
import '../app/argueless_theme.dart';
import 'version_history_dialog.dart';

/// What the app is for, how it treats the user's data, and its version.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heading = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w800,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(ArguelessTheme.gutter),
          children: [
            Text(
              'ArgueLess',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A few playful minutes a day to practise the thinking and the '
              'words that turn tricky moments into cooperative ones.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Text('Everyday friction only', style: heading),
            const SizedBox(height: 4),
            Text(
              'ArgueLess is for ordinary disagreements. If someone hurts, '
              'frightens or controls you, you do not owe them curiosity. '
              'Look after yourself and reach out to people you trust.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text('Your data', style: heading),
            const SizedBox(height: 4),
            Text(
              'Your ideas, replies and journal stay on this phone. '
              'ArgueLess uploads and shares nothing. When you tap the '
              "microphone, your phone's speech service (Google on Android, "
              'Apple on iPhone) turns your voice into words and may use '
              "its servers to do it, just as the keyboard's microphone "
              'does.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text('Backups', style: heading),
            const SizedBox(height: 4),
            Text(
              "ArgueLess keeps no copies of its own. Your phone's backup "
              'includes your practices, journal and settings, so they move '
              'with you to a new phone: on Android, the backup in your '
              'Google account or a phone-to-phone transfer; on iPhone, '
              'iCloud or a backup to your computer. To leave them out, turn '
              'off backup on Android, or iCloud backup on iPhone.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                key: const Key('version'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ArguelessTheme.radius),
                ),
                leading: const Icon(Icons.history_rounded),
                title: Text('Version ${services.changelog.current}'),
                subtitle: const Text('Tap to see what changed'),
                onTap: () =>
                    VersionHistoryDialog.show(context, services.changelog),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
