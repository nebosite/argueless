import 'dart:io';
import 'dart:math';

import 'package:argueless/src/app/app_services.dart';
import 'package:argueless/src/reminders/reminder_coordinator.dart';
import 'package:argueless/src/settings/app_settings_controller.dart';
import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_reminder_scheduler.dart';
import 'fake_speech_input.dart';
import 'fixed_clock.dart';
import 'memory_practice_log.dart';
import 'memory_reflection_log.dart';
import 'memory_reminder_settings_store.dart';

/// The real shipped content, read from disk (tests run in `app/`).
Future<ContentLibrary> shippedLibrary() =>
    JsonContentSource((name) => File('assets/content/$name').readAsString())
        .load();

/// The shipped version history (a synchronous read, safe anywhere).
final shippedChangelog = Changelog.parse(
  File('assets/changelog.json').readAsStringSync(),
);

/// Services over the shipped content, in-memory logs, a seeded picker and
/// a fixed clock (Tuesday 10 November 2026, 8 am), default settings, and
/// reminders already answered (so none are offered) unless [reminderStore]
/// says otherwise.
/// Load [library] with [shippedLibrary] in `setUpAll`: real file reads
/// do not complete inside `testWidgets`.
AppServices testServices(
  ContentLibrary library, {
  MemoryPracticeLog? practiceLog,
  MemoryReflectionLog? reflectionLog,
  FixedClock? clock,
  AppSettingsController? settings,
  FakeReminderScheduler? scheduler,
  MemoryReminderSettingsStore? reminderStore,
  FakeSpeechInput? speech,
}) {
  final log = practiceLog ?? MemoryPracticeLog();
  final time = clock ?? FixedClock(DateTime(2026, 11, 10, 8));
  return AppServices(
    library: library,
    scenarios: LibraryScenarioProvider(
      library,
      log,
      picker: ScenarioPicker(random: Random(7)),
    ),
    practiceLog: log,
    reflectionLog: reflectionLog ?? MemoryReflectionLog(),
    clock: time,
    changelog: shippedChangelog,
    settings: settings ?? AppSettingsController(),
    reminders: ReminderCoordinator(
      scheduler: scheduler ?? FakeReminderScheduler(),
      store: reminderStore ?? MemoryReminderSettingsStore.answered(),
      practiceLog: log,
      clock: time,
    ),
    speech: speech ?? FakeSpeechInput(),
  );
}

/// A tall phone, so long pages fit without scrolling.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 6000);
  tester.view.devicePixelRatio = 1.5;
  addTearDown(tester.view.reset);
}
