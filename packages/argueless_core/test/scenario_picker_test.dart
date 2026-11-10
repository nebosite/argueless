import 'dart:math';

import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  final library = testLibrary();
  final picker = ScenarioPicker(random: Random(1));
  final day = DateTime(2026, 11, 1);

  test('prefers scenarios never played', () {
    final history = [
      testRecord('one-1', 'one', day),
      testRecord('one-2', 'one', day),
    ];
    expect(picker.next(library, history, subjectId: 'one')!.id, 'one-3');
  });

  test('then the one played longest ago', () {
    final history = [
      testRecord('one-2', 'one', day),
      testRecord('one-1', 'one', day.add(const Duration(days: 1))),
      testRecord('one-3', 'one', day.add(const Duration(days: 2))),
    ];
    expect(picker.next(library, history, subjectId: 'one')!.id, 'one-2');
  });

  test('a replay counts from its latest play', () {
    final history = [
      testRecord('one-1', 'one', day),
      testRecord('one-2', 'one', day.add(const Duration(days: 1))),
      testRecord('one-3', 'one', day.add(const Duration(days: 2))),
      testRecord('one-1', 'one', day.add(const Duration(days: 3))),
    ];
    expect(picker.next(library, history, subjectId: 'one')!.id, 'one-2');
  });

  test('without a subject, picks the subject practised least', () {
    final history = [testRecord('one-1', 'one', day)];
    for (var i = 0; i < 10; i++) {
      expect(picker.next(library, history)!.subjectId, 'two');
    }
  });

  test('never offers the excluded scenario', () {
    final small = testLibrary(perSubject: 1);
    expect(
      picker.next(small, const [], subjectId: 'one', excluding: 'one-1'),
      isNull,
    );
  });
}
