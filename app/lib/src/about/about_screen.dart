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
              'Your ideas, replies and reflections stay on this phone. '
              'Nothing is uploaded or shared.',
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
