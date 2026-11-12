import 'package:argueless_core/argueless_core.dart';

import '../reminders/reminder_coordinator.dart';
import '../settings/app_settings_controller.dart';
import 'clock.dart';

/// The long-lived services the screens share.
class AppServices {
  AppServices({
    required this.library,
    required this.scenarios,
    required this.practiceLog,
    required this.reflectionLog,
    required this.changelog,
    required this.settings,
    required this.reminders,
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

  /// How the app looks.
  final AppSettingsController settings;

  /// The daily practice reminder.
  final ReminderCoordinator reminders;

  LocalDay get today => LocalDay.of(clock.now());
}
