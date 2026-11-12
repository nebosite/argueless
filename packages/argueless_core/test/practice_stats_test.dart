import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  const today = LocalDay(2026, 11, 10);
  DateTime on(int day, [int hour = 9]) => DateTime(2026, 11, day, hour);

  test('counts a streak of days ending today', () {
    final stats = PracticeStats([
      testRecord('a', 'one', on(7)),
      testRecord('a', 'one', on(8)),
      testRecord('a', 'one', on(9)),
      testRecord('a', 'one', on(10)),
      testRecord('a', 'one', on(10, 20)),
    ], today: today);
    expect(stats.streak, 4);
  });

  test("yesterday's streak still stands until today is over", () {
    final stats = PracticeStats([
      testRecord('a', 'one', on(8)),
      testRecord('a', 'one', on(9)),
    ], today: today);
    expect(stats.streak, 2);
  });

  test('a missed day ends the streak', () {
    final stats = PracticeStats([
      testRecord('a', 'one', on(7)),
      testRecord('a', 'one', on(10)),
    ], today: today);
    expect(stats.streak, 1);
    expect(PracticeStats(const [], today: today).streak, 0);
  });

  test("adds up today's practices and minutes, and all ideas", () {
    final stats = PracticeStats([
      testRecord('a', 'one', on(9), ideas: 4),
      testRecord('a', 'one', on(10), took: const Duration(minutes: 6)),
      testRecord('b', 'two', on(10, 12), took: const Duration(seconds: 270)),
    ], today: today);
    expect(stats.practisedToday, 2);
    expect(stats.minutesToday, 11);
    expect(stats.totalIdeas, 8);
    expect(stats.practisedIn('one'), 2);
  });

  test('ideas today go by local day, even for records saved in UTC', () {
    final stats = PracticeStats([
      testRecord('a', 'one', DateTime(2026, 11, 9, 23, 59).toUtc(), ideas: 5),
      testRecord('a', 'one', DateTime(2026, 11, 10, 0, 1).toUtc(), ideas: 3),
      testRecord('a', 'one', on(10, 20), ideas: 0),
    ], today: today);
    expect(stats.ideasToday, 3);
    expect(stats.totalIdeas, 8);
  });
}
