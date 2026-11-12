import 'package:argueless/src/app/argueless_app.dart';
import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/failing_practice_log.dart';
import 'fakes/fake_speech_input.dart';
import 'fakes/fixed_clock.dart';
import 'fakes/memory_practice_log.dart';
import 'fakes/test_services.dart';

void main() {
  late ContentLibrary library;
  setUpAll(() async => library = await shippedLibrary());

  Future<void> rateEverything(WidgetTester tester) async {
    final keys = [
      for (final chip in tester.widgetList<ChoiceChip>(find.byType(ChoiceChip)))
        if ((chip.key! as ValueKey<String>).value.endsWith('-3')) chip.key!,
    ];
    for (final key in keys) {
      await tester.tap(find.byKey(key));
    }
    await tester.pumpAndSettle();
  }

  Future<void> addIdea(WidgetTester tester, String text) async {
    await tester.enterText(find.byKey(const Key('idea-field')), text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }

  /// The scenario whose situation is on screen (the screen swaps scenarios
  /// in place for "Another scenario").
  Scenario current(WidgetTester tester) => library.scenarios.singleWhere(
    (s) => find.text(s.situation).evaluate().isNotEmpty,
  );

  /// Plays the open practice to the finish view and returns its scenario.
  Future<Scenario> playThrough(WidgetTester tester, FixedClock clock) async {
    final scenario = current(tester);
    await addIdea(tester, 'Maybe they know something I do not');
    await tester.tap(find.text('Show me suggestions'));
    await tester.pumpAndSettle();
    await rateEverything(tester);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await addIdea(tester, 'Tell me more?');
    await tester.tap(find.text('Show me suggestions'));
    await tester.pumpAndSettle();
    await rateEverything(tester);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tell me more?'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('send-reply')));
    await tester.pumpAndSettle();
    clock.time = clock.time.add(const Duration(minutes: 3));
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    return scenario;
  }

  testWidgets('a whole practice, from home and back, is saved', (tester) async {
    useTallScreen(tester);
    final log = MemoryPracticeLog();
    final clock = FixedClock(DateTime(2026, 11, 10, 8));
    final services = testServices(library, practiceLog: log, clock: clock);
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('today')));
    await tester.pumpAndSettle();
    final scenario = current(tester);
    expect(find.text(scenario.situation), findsOneWidget);

    // Reframes: nothing to continue with until there is an idea.
    FilledButton button(String label) => tester.widget<FilledButton>(
      find.ancestor(of: find.text(label), matching: find.byType(FilledButton)),
    );
    expect(button('Show me suggestions').onPressed, isNull);
    await addIdea(tester, 'Maybe they know something I do not');
    await addIdea(tester, 'We both want this to go well');
    expect(find.text('2 ideas. Keep going!'), findsOneWidget);
    await tester.tap(find.text('Show me suggestions'));
    await tester.pumpAndSettle();

    // Review: suggestions shown; rating unlocks Next.
    expect(find.text(scenario.reframes.first), findsOneWidget);
    expect(button('Next').onPressed, isNull);
    await rateEverything(tester);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Phrases: one typed but never submitted still counts.
    await tester.enterText(
      find.byKey(const Key('idea-field')),
      'Tell me more about that?',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show me suggestions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(scenario.phrases[1]));
    await rateEverything(tester);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Role-play: the liked suggestion is a choice; pick it and send.
    expect(find.text('Tell me more about that?'), findsOneWidget);
    await tester.tap(find.text(scenario.phrases[1]));
    await tester.pumpAndSettle();
    expect(find.text(scenario.roleplay.opening), findsOneWidget);
    await tester.tap(find.byKey(const Key('send-reply')));
    await tester.pumpAndSettle();
    expect(find.text(scenario.roleplay.partnerReply), findsOneWidget);

    clock.time = clock.time.add(const Duration(minutes: 6));
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    expect(find.text('Nicely done!'), findsOneWidget);
    expect(find.text(scenario.takeaway), findsOneWidget);
    final record = log.records.single;
    expect(record.scenarioId, scenario.id);
    expect(record.reframes.ideas, hasLength(2));
    expect(record.phrases.ideas, ['Tell me more about that?']);
    expect(record.phrases.liked, [scenario.phrases[1]]);
    expect(record.favourite, scenario.phrases[1]);
    expect(record.reply, scenario.phrases[1]);
    expect(record.reframes.ratings.values, everyElement(3));
    expect(record.duration, const Duration(minutes: 6));

    await tester.tap(find.text('Done for now'));
    await tester.pumpAndSettle();
    expect(find.text('One more?'), findsOneWidget);
    expect(find.text('1 day'), findsOneWidget);
  });

  testWidgets('"Another scenario" starts a new one in the same subject', (
    tester,
  ) async {
    useTallScreen(tester);
    final log = MemoryPracticeLog();
    final clock = FixedClock(DateTime(2026, 11, 10, 8));
    final services = testServices(library, practiceLog: log, clock: clock);
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.text('When to push back'));
    await tester.pumpAndSettle();

    final first = await playThrough(tester, clock);
    await tester.tap(find.text('Another scenario'));
    await tester.pumpAndSettle();
    final second = current(tester);
    expect(second.subjectId, 'rebuttal');
    expect(second.id, isNot(first.id));
    expect(find.text(second.situation), findsOneWidget);

    await playThrough(tester, clock);
    expect(log.records.map((r) => r.scenarioId), [first.id, second.id]);
    await tester.tap(find.text('Done for now'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Done today: 2'), findsOneWidget);
  });

  testWidgets('leaving with ideas asks first', (tester) async {
    useTallScreen(tester);
    final services = testServices(library);
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confusion is a signal'));
    await tester.pumpAndSettle();
    await addIdea(tester, 'I could ask');

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Leave this practice?'), findsOneWidget);
    await tester.tap(find.text('Keep going'));
    await tester.pumpAndSettle();
    expect(find.text('I could ask'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave'));
    await tester.pumpAndSettle();
    expect(find.text('Pick a subject'), findsOneWidget);
  });

  testWidgets('a failed save keeps the practice and can be retried', (
    tester,
  ) async {
    useTallScreen(tester);
    final log = FailingPracticeLog();
    final clock = FixedClock(DateTime(2026, 11, 10, 8));
    await tester.pumpWidget(
      ArguelessApp(
        services: testServices(library, practiceLog: log, clock: clock),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('today')));
    await tester.pumpAndSettle();

    await playThrough(tester, clock);
    expect(find.text("Your practice couldn't be saved"), findsOneWidget);
    expect(log.records, isEmpty);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Nicely done!'), findsOneWidget);
    expect(log.records, hasLength(1));
  });

  testWidgets('choosing another favourite keeps a reply the user edited', (
    tester,
  ) async {
    useTallScreen(tester);
    await tester.pumpWidget(ArguelessApp(services: testServices(library)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('today')));
    await tester.pumpAndSettle();
    for (var round = 0; round < 2; round++) {
      await addIdea(tester, 'An idea');
      await tester.tap(find.text('Show me suggestions'));
      await tester.pumpAndSettle();
      await rateEverything(tester);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    // Only the user's own phrase is offered: pick it, edit, then re-pick.
    await tester.tap(find.text('An idea'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('reply-field')), 'My words');
    await tester.tap(find.widgetWithText(ListTile, 'An idea'));
    await tester.pumpAndSettle();
    expect(find.text('My words'), findsOneWidget);
  });

  testWidgets('ideas can be spoken, and the keyboard starts hidden', (
    tester,
  ) async {
    useTallScreen(tester);
    final speech = FakeSpeechInput();
    await tester.pumpWidget(
      ArguelessApp(services: testServices(library, speech: speech)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('today')));
    await tester.pumpAndSettle();
    expect(
      FocusManager.instance.primaryFocus?.context?.widget,
      isNot(isA<EditableText>()),
    );
    expect(tester.testTextInput.isVisible, isFalse);

    await tester.tap(find.byKey(const Key('mic')));
    await tester.pump();
    speech.say('They might be tired');
    speech.finish();
    await tester.pump();
    expect(find.text('They might be tired'), findsOneWidget);
    expect(tester.testTextInput.isVisible, isFalse, reason: 'still hidden');
    await tester.tap(find.byTooltip('Add idea'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show me suggestions'));
    await tester.pumpAndSettle();
    expect(find.text('They might be tired'), findsOneWidget);
    expect(find.text('Yours (1)'), findsOneWidget);
  });

  testWidgets('the role-play shows their line before the choice of reply', (
    tester,
  ) async {
    useTallScreen(tester);
    await tester.pumpWidget(ArguelessApp(services: testServices(library)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('today')));
    await tester.pumpAndSettle();
    final scenario = current(tester);
    for (var round = 0; round < 2; round++) {
      expect(
        find.textContaining(round == 0 ? 'How else' : 'or to yourself'),
        findsWidgets,
      );
      await addIdea(tester, 'An idea');
      await tester.tap(find.text('Show me suggestions'));
      await tester.pumpAndSettle();
      expect(find.textContaining('ring true and bring up a softer'), findsOne);
      await rateEverything(tester);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    final opening = find.text(scenario.roleplay.opening);
    expect(opening, findsOneWidget, reason: 'shown before choosing');
    expect(
      tester.getTopLeft(opening).dy,
      lessThan(tester.getTopLeft(find.text('Pick your reply')).dy),
    );
    expect(find.byKey(const Key('reply-field')), findsNothing);
    await tester.tap(find.text('An idea'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('send-reply')));
    await tester.pumpAndSettle();
    expect(find.text('Pick your reply'), findsNothing, reason: 'chat reads on');
    expect(find.text(scenario.roleplay.partnerReply), findsOneWidget);
  });
}
