import 'dart:io';
import 'dart:math';

import 'package:argueless/src/app/app_services.dart';
import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fixed_clock.dart';
import 'memory_practice_log.dart';
import 'memory_reflection_log.dart';

/// The real shipped content, read from disk (tests run in `app/`).
Future<ContentLibrary> shippedLibrary() =>
    JsonContentSource((name) => File('assets/content/$name').readAsString())
        .load();

/// The shipped version history (a synchronous read, safe anywhere).
final shippedChangelog = Changelog.parse(
  File('assets/changelog.json').readAsStringSync(),
);

/// Services over the shipped content, in-memory logs, a seeded picker and
/// a fixed clock (Tuesday 10 November 2026, 8 am).
/// Load [library] with [shippedLibrary] in `setUpAll`: real file reads
/// do not complete inside `testWidgets`.
AppServices testServices(
  ContentLibrary library, {
  MemoryPracticeLog? practiceLog,
  MemoryReflectionLog? reflectionLog,
  FixedClock? clock,
}) {
  final log = practiceLog ?? MemoryPracticeLog();
  return AppServices(
    library: library,
    scenarios: LibraryScenarioProvider(
      library,
      log,
      picker: ScenarioPicker(random: Random(7)),
    ),
    practiceLog: log,
    reflectionLog: reflectionLog ?? MemoryReflectionLog(),
    clock: clock ?? FixedClock(DateTime(2026, 11, 10, 8)),
    changelog: shippedChangelog,
  );
}

/// A tall phone, so long pages fit without scrolling.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 6000);
  tester.view.devicePixelRatio = 1.5;
  addTearDown(tester.view.reset);
}
