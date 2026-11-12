import 'package:argueless/src/app/argueless_app.dart';
import 'package:argueless/src/reminders/reminder_coordinator.dart';
import 'package:argueless/src/settings/app_settings_controller.dart';
import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_reminder_scheduler.dart';
import 'fakes/fixed_clock.dart';
import 'fakes/memory_practice_log.dart';
import 'fakes/memory_reminder_settings_store.dart';
import 'fakes/test_services.dart';

void main() {
  late ContentLibrary library;
  setUpAll(() async => library = await shippedLibrary());

  /// A practice finished at [at].
  PracticeRecord practice(DateTime at) => PracticeRecord(
    scenarioId: 'lg-01',
    subjectId: 'letting-go',
    startedAt: at.subtract(const Duration(minutes: 5)),
    finishedAt: at,
    reframes: const RoundRecord(ratings: {'curious': 3, 'generous': 2}),
    phrases: const RoundRecord(ratings: {'open': 4}),
  );

  group('ReminderCoordinator', () {
    ReminderCoordinator coordinator({
      required FakeReminderScheduler scheduler,
      required MemoryReminderSettingsStore store,
      List<PracticeRecord> records = const [],
      DateTime? now,
    }) => ReminderCoordinator(
      scheduler: scheduler,
      store: store,
      practiceLog: MemoryPracticeLog([...records]),
      clock: FixedClock(now ?? DateTime(2026, 11, 10, 8)),
    );

    test('turned on, it schedules today at the chosen time', () async {
      final scheduler = FakeReminderScheduler();
      final store = MemoryReminderSettingsStore();
      final reminders = coordinator(scheduler: scheduler, store: store);
      expect(await reminders.shouldOffer(), isTrue);

      expect(await reminders.setEnabled(true), EnableResult.enabled);
      expect(scheduler.scheduled, DateTime(2026, 11, 10, 19));
      expect(await reminders.shouldOffer(), isFalse);

      await reminders.setTime(7, 30);
      expect(scheduler.scheduled, DateTime(2026, 11, 11, 7, 30));
    });

    test('a day already practised starts the reminders tomorrow', () async {
      final scheduler = FakeReminderScheduler();
      final reminders = coordinator(
        scheduler: scheduler,
        store: MemoryReminderSettingsStore(
          const ReminderSettings(enabled: true, hour: 19, minute: 0),
        ),
        records: [practice(DateTime(2026, 11, 10, 7))],
      );
      await reminders.sync();
      expect(scheduler.scheduled, DateTime(2026, 11, 11, 19));
    });

    test('refused permission leaves reminders off', () async {
      final scheduler = FakeReminderScheduler(granted: false)
        ..grantOnRequest = false;
      final store = MemoryReminderSettingsStore();
      final reminders = coordinator(scheduler: scheduler, store: store);
      expect(await reminders.setEnabled(true), EnableResult.denied);
      expect(store.saved!.enabled, isFalse);
      expect(scheduler.scheduled, isNull);
      expect(await reminders.shouldOffer(), isFalse);
    });

    test('permission taken away later switches reminders off', () async {
      final scheduler = FakeReminderScheduler();
      final store = MemoryReminderSettingsStore();
      final reminders = coordinator(scheduler: scheduler, store: store);
      await reminders.setEnabled(true);
      scheduler.granted = false;
      await reminders.sync();
      expect(store.saved!.enabled, isFalse);
      expect(scheduler.scheduled, isNull);
      // Already allowed when turned on, and never asked again after.
      expect(scheduler.calls, isNot(contains('request')));
    });

    test('declining the offer saves it, so it is not made again', () async {
      final store = MemoryReminderSettingsStore();
      final reminders = coordinator(
        scheduler: FakeReminderScheduler(),
        store: store,
      );
      await reminders.decline();
      expect(await reminders.shouldOffer(), isFalse);
      expect(store.saved!.enabled, isFalse);
    });

    test(
      'a glitch checking permission leaves reminders as they were',
      () async {
        final scheduler = FakeReminderScheduler();
        final store = MemoryReminderSettingsStore();
        final reminders = coordinator(scheduler: scheduler, store: store);
        await reminders.setEnabled(true);
        scheduler.calls.clear();
        scheduler.checkFails = true;
        await reminders.sync();
        expect(store.saved!.enabled, isTrue);
        expect(scheduler.calls, isEmpty, reason: 'nothing cancelled');
        expect(scheduler.scheduled, isNotNull);
      },
    );

    test('a failed schedule is reported, not hidden', () async {
      final scheduler = FakeReminderScheduler()..scheduleFails = true;
      final reminders = coordinator(
        scheduler: scheduler,
        store: MemoryReminderSettingsStore(),
      );
      await expectLater(reminders.setEnabled(true), throwsStateError);
    });

    test('a practice just before midnight was yesterday', () async {
      final scheduler = FakeReminderScheduler();
      final reminders = coordinator(
        scheduler: scheduler,
        store: MemoryReminderSettingsStore(
          const ReminderSettings(enabled: true, hour: 19, minute: 0),
        ),
        records: [practice(DateTime(2026, 11, 9, 23, 58))],
        now: DateTime(2026, 11, 10, 0, 2),
      );
      await reminders.sync();
      expect(scheduler.scheduled, DateTime(2026, 11, 10, 19));
    });

    test('a practice just after midnight was today', () async {
      final scheduler = FakeReminderScheduler();
      final reminders = coordinator(
        scheduler: scheduler,
        store: MemoryReminderSettingsStore(
          const ReminderSettings(enabled: true, hour: 19, minute: 0),
        ),
        // Saved in UTC, as the log does; read back as a local day.
        records: [practice(DateTime(2026, 11, 10, 0, 1).toUtc())],
        now: DateTime(2026, 11, 10, 18),
      );
      await reminders.sync();
      expect(scheduler.scheduled, DateTime(2026, 11, 11, 19));
    });
  });

  group('the offer after the first practice', () {
    /// Opens a practice and comes back home with one saved. (The whole
    /// flow is covered in practice_flow_test; leaving an untouched one is
    /// enough to return home.)
    Future<void> finishAPractice(
      WidgetTester tester,
      MemoryPracticeLog log,
    ) async {
      await tester.tap(find.byKey(const Key('today')));
      await tester.pumpAndSettle();
      log.records.add(practice(DateTime(2026, 11, 10, 8)));
      await tester.pageBack();
      await tester.pumpAndSettle();
    }

    testWidgets('yes turns reminders on, starting tomorrow', (tester) async {
      useTallScreen(tester);
      final log = MemoryPracticeLog();
      final scheduler = FakeReminderScheduler(granted: false);
      final store = MemoryReminderSettingsStore();
      await tester.pumpWidget(
        ArguelessApp(
          services: testServices(
            library,
            practiceLog: log,
            scheduler: scheduler,
            reminderStore: store,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('A gentle daily nudge?'), findsNothing);

      await finishAPractice(tester, log);
      expect(find.text('A gentle daily nudge?'), findsOneWidget);
      await tester.tap(find.text('Yes, remind me'));
      await tester.pumpAndSettle();
      expect(store.saved!.enabled, isTrue);
      expect(scheduler.calls, contains('request'));
      expect(scheduler.scheduled, DateTime(2026, 11, 11, 19));
    });

    testWidgets('no thanks is never asked again', (tester) async {
      useTallScreen(tester);
      final log = MemoryPracticeLog();
      final scheduler = FakeReminderScheduler(granted: false);
      final store = MemoryReminderSettingsStore();
      await tester.pumpWidget(
        ArguelessApp(
          services: testServices(
            library,
            practiceLog: log,
            scheduler: scheduler,
            reminderStore: store,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await finishAPractice(tester, log);
      await tester.tap(find.text('No thanks'));
      await tester.pumpAndSettle();
      expect(scheduler.calls, isNot(contains('request')));
      expect(store.saved!.enabled, isFalse);

      await finishAPractice(tester, log);
      expect(find.text('A gentle daily nudge?'), findsNothing);
    });

    testWidgets('leaving without answering asks again next time', (
      tester,
    ) async {
      useTallScreen(tester);
      final log = MemoryPracticeLog();
      final store = MemoryReminderSettingsStore();
      await tester.pumpWidget(
        ArguelessApp(
          services: testServices(
            library,
            practiceLog: log,
            reminderStore: store,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await finishAPractice(tester, log);
      // The phone's back gesture.
      Navigator.of(tester.element(find.byType(AlertDialog))).pop();
      await tester.pumpAndSettle();
      expect(store.saved, isNull);

      await finishAPractice(tester, log);
      expect(find.text('A gentle daily nudge?'), findsOneWidget);
    });

    testWidgets('leaving a practice unfinished does not offer', (tester) async {
      useTallScreen(tester);
      final log = MemoryPracticeLog([practice(DateTime(2026, 11, 9, 8))]);
      await tester.pumpWidget(
        ArguelessApp(
          services: testServices(
            library,
            practiceLog: log,
            reminderStore: MemoryReminderSettingsStore(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('today')));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('A gentle daily nudge?'), findsNothing);
    });

    testWidgets('yes, then a refusal, says where to allow it', (tester) async {
      useTallScreen(tester);
      final log = MemoryPracticeLog();
      final scheduler = FakeReminderScheduler(granted: false)
        ..grantOnRequest = false;
      final store = MemoryReminderSettingsStore();
      await tester.pumpWidget(
        ArguelessApp(
          services: testServices(
            library,
            practiceLog: log,
            scheduler: scheduler,
            reminderStore: store,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await finishAPractice(tester, log);
      await tester.tap(find.text('Yes, remind me'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Notifications are off'), findsOneWidget);
      expect(store.saved!.enabled, isFalse);

      await tester.pumpAndSettle(const Duration(seconds: 5));
      await finishAPractice(tester, log);
      expect(find.text('A gentle daily nudge?'), findsNothing);
    });
  });

  group('settings page', () {
    testWidgets('the reminder switch and time', (tester) async {
      useTallScreen(tester);
      final scheduler = FakeReminderScheduler();
      final store = MemoryReminderSettingsStore.answered();
      await tester.pumpWidget(
        ArguelessApp(
          services: testServices(
            library,
            scheduler: scheduler,
            reminderStore: store,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('reminder-time')), findsNothing);
      await tester.tap(find.byKey(const Key('reminder-switch')));
      await tester.pumpAndSettle();
      expect(store.saved!.enabled, isTrue);
      expect(find.text('Around 7:00 PM'), findsOneWidget);

      await tester.tap(find.byKey(const Key('reminder-time')));
      await tester.pumpAndSettle();
      expect(find.text('Remind me at'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('reminder-switch')));
      await tester.pumpAndSettle();
      expect(store.saved!.enabled, isFalse);
      expect(scheduler.scheduled, isNull);
    });

    testWidgets('a refused permission explains where to allow it', (
      tester,
    ) async {
      useTallScreen(tester);
      final scheduler = FakeReminderScheduler(granted: false)
        ..grantOnRequest = false;
      await tester.pumpWidget(
        ArguelessApp(services: testServices(library, scheduler: scheduler)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('reminder-switch')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Notifications are turned off'),
        findsOneWidget,
      );
    });

    testWidgets('appearance, colour and text size apply at once', (
      tester,
    ) async {
      useTallScreen(tester);
      final settings = AppSettingsController();
      await tester.pumpWidget(
        ArguelessApp(services: testServices(library, settings: settings)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();

      MaterialApp app() => tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app().themeMode, ThemeMode.system);
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(settings.value.appearance, Appearance.dark);
      expect(app().themeMode, ThemeMode.dark);

      await tester.tap(find.bySemanticsLabel('Teal'));
      await tester.pumpAndSettle();
      expect(settings.value.themeColor, 0xFF00796B);
      expect(app().theme!.colorScheme.primary, const Color(0xFF00796B));

      // Text starts smaller than the phone's own size.
      expect(find.text('70%'), findsOneWidget);
      double scaled() =>
          MediaQuery.of(tester.element(find.text('Text size'))).textScaler
              .scale(10);
      expect(scaled(), closeTo(7, 0.01));
      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      expect(settings.value.textPercent, 80);
      expect(find.text('80%'), findsOneWidget);
      expect(scaled(), closeTo(8, 0.01));
    });
  });

  group('progress', () {
    testWidgets('shows self-ratings by criterion', (tester) async {
      useTallScreen(tester);
      PracticeRecord earlier(int day) => PracticeRecord(
        scenarioId: 'lg-02',
        subjectId: 'letting-go',
        startedAt: DateTime(2026, 9, day, 9),
        finishedAt: DateTime(2026, 9, day, 9, 5),
        reframes: const RoundRecord(ratings: {'curious': 1, 'shared': 2}),
      );
      final log = MemoryPracticeLog([
        // Three lately and three before for Curious: enough to compare.
        for (final day in [7, 8, 9]) practice(DateTime(2026, 11, day, 9)),
        for (final day in [1, 2, 3]) earlier(day),
      ]);
      await tester.pumpWidget(
        ArguelessApp(services: testServices(library, practiceLog: log)),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('progress')));
      await tester.pumpAndSettle();

      expect(find.text('How you rate yourself'), findsOneWidget);
      expect(find.text('Reframes'), findsOneWidget);
      expect(find.text('Phrases'), findsOneWidget);
      expect(find.text('Curious'), findsOneWidget);
      expect(find.text('3 ratings lately · before: Not yet'), findsOneWidget);
      expect(find.text('Solid'), findsOneWidget);
      expect(find.text('Nailed it'), findsOneWidget);
      // Shared ground was only rated before the last 4 weeks.
      expect(find.text('Last rated over 4 weeks ago'), findsOneWidget);
      // No numbers that read like a score.
      expect(find.textContaining('3.0'), findsNothing);
      expect(find.byKey(const Key('before-mark')), findsOneWidget);
    });

    testWidgets('with no practice yet, says where ratings will show', (
      tester,
    ) async {
      useTallScreen(tester);
      await tester.pumpWidget(ArguelessApp(services: testServices(library)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('progress')));
      await tester.pumpAndSettle();
      expect(
        find.text('Your self-ratings from each practice will show here.'),
        findsOneWidget,
      );
    });
  });
}
