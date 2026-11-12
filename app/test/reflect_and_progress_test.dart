import 'package:argueless/src/app/argueless_app.dart';
import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_speech_input.dart';
import 'fakes/memory_practice_log.dart';
import 'fakes/memory_reflection_log.dart';
import 'fakes/test_services.dart';

void main() {
  late ContentLibrary library;
  setUpAll(() async => library = await shippedLibrary());

  const today = LocalDay(2026, 11, 10);

  bool keyboardOpen(WidgetTester tester) =>
      tester.testTextInput.isVisible &&
      FocusManager.instance.primaryFocus?.context?.widget is EditableText;

  testWidgets('the journal saves today and shows on home', (tester) async {
    useTallScreen(tester);
    final log = MemoryReflectionLog();
    final services = testServices(library, reflectionLog: log);
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();
    expect(find.text('Journal'), findsOneWidget);

    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    expect(keyboardOpen(tester), isFalse, reason: 'keyboard starts hidden');
    final save = find.byKey(const Key('save-reflection'));
    expect(tester.widget<FilledButton>(save).onPressed, isNull);

    await tester.enterText(
      find.byKey(const Key('journal-field')),
      '  Caught myself fixing instead of listening.  ',
    );
    await tester.pump();
    await tester.tap(save);
    await tester.pumpAndSettle();

    final saved = log.reflections.single;
    expect(saved.day, today);
    expect(saved.note, 'Caught myself fixing instead of listening.');
    expect(find.text('Journal written today'), findsOneWidget);

    // Opening it again edits the same day.
    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    expect(find.text('Caught myself fixing instead of listening.'), findsOne);
    await tester.enterText(find.byKey(const Key('journal-field')), 'Better.');
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(log.reflections.single.note, 'Better.');
  });

  testWidgets('speaking adds to what is already written', (tester) async {
    useTallScreen(tester);
    final speech = FakeSpeechInput();
    final log = MemoryReflectionLog();
    await tester.pumpWidget(
      ArguelessApp(
        services: testServices(library, reflectionLog: log, speech: speech),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('journal-field')), 'Typed.');

    await tester.tap(find.byKey(const Key('mic')));
    await tester.pump();
    expect(speech.isListening, isTrue);
    expect(find.byTooltip('Stop listening'), findsOneWidget);
    speech.say('then');
    speech.say('then I spoke');
    await tester.pump();
    expect(find.text('Typed. then I spoke'), findsOneWidget);

    // Tapping again stops.
    await tester.tap(find.byKey(const Key('mic')));
    await tester.pump();
    expect(speech.isListening, isFalse);
    expect(find.byTooltip('Speak instead of typing'), findsOneWidget);

    await tester.tap(find.byKey(const Key('save-reflection')));
    await tester.pumpAndSettle();
    expect(log.reflections.single.note, 'Typed. then I spoke');
  });

  testWidgets('no speech recognition says where to look', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(
      ArguelessApp(
        services: testServices(
          library,
          speech: FakeSpeechInput(available: false),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('mic')));
    await tester.pumpAndSettle();
    expect(find.textContaining("Couldn't start listening"), findsOneWidget);
    expect(find.byTooltip('Speak instead of typing'), findsOneWidget);
  });

  testWidgets('progress shows the journal, newest first, and old counts', (
    tester,
  ) async {
    useTallScreen(tester);
    final services = testServices(
      library,
      reflectionLog: MemoryReflectionLog([
        const Reflection(day: LocalDay(2026, 11, 3), automatic: 1, conflict: 1),
        const Reflection(day: LocalDay(2026, 11, 8)),
        const Reflection(day: LocalDay(2026, 11, 9), note: 'Listened well.'),
      ]),
    );
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('progress')));
    await tester.pumpAndSettle();

    final newest = find.text('Listened well.');
    final oldest = find.text(
      'Tricky moments: 1 generous right away, 0 turned around, '
      '1 into conflict.',
    );
    expect(newest, findsOneWidget);
    expect(oldest, findsOneWidget);
    expect(find.text('Sun 8 Nov'), findsNothing, reason: 'empty entry');
    expect(
      tester.getTopLeft(newest).dy,
      lessThan(tester.getTopLeft(oldest).dy),
    );
  });

  testWidgets('progress with nothing yet says so', (tester) async {
    useTallScreen(tester);
    final services = testServices(library);
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('progress')));
    await tester.pumpAndSettle();
    expect(
      find.text('What you write in the journal will show here.'),
      findsOneWidget,
    );
  });

  testWidgets('home counts the ideas written', (tester) async {
    useTallScreen(tester);
    PracticeRecord done(DateTime at, List<String> ideas) => PracticeRecord(
      scenarioId: 'lg-01',
      subjectId: 'letting-go',
      startedAt: at,
      finishedAt: at.add(const Duration(minutes: 5)),
      reframes: RoundRecord(ideas: ideas),
    );
    final services = testServices(
      library,
      practiceLog: MemoryPracticeLog([
        done(DateTime(2026, 11, 9, 9), ['a', 'b']),
        done(DateTime(2026, 11, 10, 7), ['c', 'd', 'e']),
      ]),
    );
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();
    expect(find.text('5 ideas'), findsOneWidget);
    expect(find.textContaining('3 ideas. Aim for'), findsOneWidget);
  });

  testWidgets('listening that ends with nothing heard changes nothing', (
    tester,
  ) async {
    useTallScreen(tester);
    final speech = FakeSpeechInput();
    await tester.pumpWidget(
      ArguelessApp(services: testServices(library, speech: speech)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('journal-field')), 'Kept.');
    await tester.tap(find.byKey(const Key('mic')));
    await tester.pump();
    speech.finish();
    await tester.pump();
    expect(find.byTooltip('Speak instead of typing'), findsOneWidget);
    expect(find.text('Kept.'), findsOneWidget);
  });

  testWidgets('a second dictation adds to the first', (tester) async {
    useTallScreen(tester);
    final speech = FakeSpeechInput();
    await tester.pumpWidget(
      ArguelessApp(services: testServices(library, speech: speech)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    for (final words in ['First part.', 'Second part.']) {
      await tester.tap(find.byKey(const Key('mic')));
      await tester.pump();
      speech.say(words);
      speech.finish();
      await tester.pump();
    }
    expect(find.text('First part. Second part.'), findsOneWidget);
  });

  testWidgets('words after a hand edit do not overwrite it', (tester) async {
    useTallScreen(tester);
    final speech = FakeSpeechInput();
    await tester.pumpWidget(
      ArguelessApp(services: testServices(library, speech: speech)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('mic')));
    await tester.pump();
    speech.say('I noticed');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('journal-field')), 'Fixed.');
    speech.say('I noticed a late word');
    await tester.pump();
    expect(find.text('Fixed.'), findsOneWidget);
  });

  testWidgets('leaving while listening stops it', (tester) async {
    useTallScreen(tester);
    final speech = FakeSpeechInput();
    await tester.pumpWidget(
      ArguelessApp(services: testServices(library, speech: speech)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('mic')));
    await tester.pump();
    expect(speech.isListening, isTrue);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(speech.isListening, isFalse);
    speech.say('too late');
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
