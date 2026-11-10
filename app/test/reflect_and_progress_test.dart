import 'package:argueless/src/app/argueless_app.dart';
import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/memory_reflection_log.dart';
import 'fakes/test_services.dart';

void main() {
  late ContentLibrary library;
  setUpAll(() async => library = await shippedLibrary());

  const today = LocalDay(2026, 11, 10);

  Future<void> tapIn(WidgetTester tester, String counter, String button) async {
    await tester.tap(
      find.descendant(
        of: find.byKey(Key(counter)),
        matching: find.byTooltip(button),
      ),
    );
    await tester.pump();
  }

  testWidgets('reflecting saves today and shows on home', (tester) async {
    useTallScreen(tester);
    final log = MemoryReflectionLog();
    final services = testServices(library, reflectionLog: log);
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    await tapIn(tester, 'automatic', 'One more');
    await tapIn(tester, 'automatic', 'One more');
    await tapIn(tester, 'recovered', 'One more');
    await tapIn(tester, 'conflict', 'One more');
    await tapIn(tester, 'conflict', 'One fewer');
    await tapIn(tester, 'conflict', 'One more');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-reflection')));
    await tester.pumpAndSettle();

    final saved = log.reflections.single;
    expect(saved.day, today);
    expect([saved.automatic, saved.recovered, saved.conflict], [2, 1, 1]);
    expect(find.text('Reflected today'), findsOneWidget);
    expect(find.text('3 went generously. Tap to change.'), findsOneWidget);

    // Opening it again edits the same day.
    await tester.tap(find.byKey(const Key('reflect')));
    await tester.pumpAndSettle();
    await tapIn(tester, 'conflict', 'One fewer');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-reflection')));
    await tester.pumpAndSettle();
    expect(log.reflections.single.conflict, 0);
  });

  testWidgets('progress charts reflections and the generous share', (
    tester,
  ) async {
    useTallScreen(tester);
    final services = testServices(
      library,
      reflectionLog: MemoryReflectionLog([
        const Reflection(day: LocalDay(2026, 11, 3), automatic: 1, conflict: 1),
        const Reflection(
          day: LocalDay(2026, 11, 9),
          automatic: 3,
          recovered: 1,
        ),
      ]),
    );
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('progress')));
    await tester.pumpAndSettle();

    // The newest day with a reflection is described to start with.
    expect(
      find.text(
        'Mon 9 Nov: 3 generous right away, 1 turned around, 0 conflict.',
      ),
      findsOneWidget,
    );
    expect(find.text('100%'), findsOneWidget, reason: 'this week');
    expect(find.text('50%'), findsOneWidget, reason: 'last week');

    await tester.tap(find.text('12 weeks'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Week of 9 Nov: 3 generous'), findsOneWidget);
  });

  testWidgets('progress with nothing yet says so', (tester) async {
    useTallScreen(tester);
    final services = testServices(library);
    await tester.pumpWidget(ArguelessApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('progress')));
    await tester.pumpAndSettle();
    expect(find.text('No reflections in this range yet.'), findsOneWidget);
    expect(find.text('–'), findsNWidgets(2));
  });
}
