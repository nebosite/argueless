import 'package:flutter/material.dart';

import '../app/app_services.dart';
import 'practice_screen.dart';

/// Asks for the next scenario and opens a practice on it.
class PracticeLauncher {
  const PracticeLauncher(this.services);

  final AppServices services;

  /// Opens a practice in [subjectId] (any subject if null), and completes
  /// when the user leaves it.
  Future<void> start(BuildContext context, {String? subjectId}) async {
    final scenario = await services.scenarios.next(subjectId: subjectId);
    if (!context.mounted) return;
    if (scenario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to practise here yet.')),
      );
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PracticeScreen(services: services, scenario: scenario),
      ),
    );
  }
}
