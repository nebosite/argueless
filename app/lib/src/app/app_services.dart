import 'package:argueless_core/argueless_core.dart';

import 'clock.dart';

/// The long-lived services the screens share.
class AppServices {
  AppServices({
    required this.library,
    required this.scenarios,
    required this.practiceLog,
    required this.reflectionLog,
    required this.changelog,
    this.clock = const Clock(),
  });

  /// The subjects, rubrics and scenarios.
  final ContentLibrary library;

  /// Decides what to practise next.
  final ScenarioProvider scenarios;

  final PracticeLog practiceLog;
  final ReflectionLog reflectionLog;
  final Clock clock;

  /// Every version's notes; its newest is this build's version.
  final Changelog changelog;

  LocalDay get today => LocalDay.of(clock.now());
}
