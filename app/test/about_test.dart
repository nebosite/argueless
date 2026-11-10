import 'package:argueless/src/app/argueless_app.dart';
import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/test_services.dart';

void main() {
  late ContentLibrary library;
  setUpAll(() async => library = await shippedLibrary());

  testWidgets('about shows the version; tapping it shows the history', (
    tester,
  ) async {
    useTallScreen(tester);
    await tester.pumpWidget(ArguelessApp(services: testServices(library)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('About ArgueLess'));
    await tester.pumpAndSettle();
    final current = shippedChangelog.current;
    expect(find.text('Version $current'), findsOneWidget);

    await tester.tap(find.byKey(const Key('version')));
    await tester.pumpAndSettle();
    expect(find.text('What changed'), findsOneWidget);
    for (final note in shippedChangelog.notes) {
      expect(find.textContaining('${note.version}  ·'), findsOneWidget);
      for (final change in note.changes) {
        expect(find.text('•  $change'), findsOneWidget);
      }
    }

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('What changed'), findsNothing);
  });
}
