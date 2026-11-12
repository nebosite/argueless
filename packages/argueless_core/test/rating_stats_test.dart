import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  final library = testLibrary();
  const today = LocalDay(2026, 11, 10);

  PracticeRecord record(
    LocalDay day, {
    String subject = 'one',
    Map<String, int> reframe = const {},
    Map<String, int> phrases = const {},
  }) {
    final at = DateTime(day.year, day.month, day.day, 9);
    return PracticeRecord(
      scenarioId: '$subject-1',
      subjectId: subject,
      startedAt: at,
      finishedAt: at.add(const Duration(minutes: 5)),
      reframes: RoundRecord(ratings: reframe),
      phrases: RoundRecord(ratings: phrases),
    );
  }

  test('criteriaFor lists the library rubric, then subject-only ids', () {
    expect(
      [for (final c in library.criteriaFor(RubricKind.reframe)) c.id],
      ['a', 'b', 'x'],
    );
    expect(
      [for (final c in library.criteriaFor(RubricKind.phrases)) c.id],
      ['a', 'b'],
    );
  });

  test('averages recent ratings apart from earlier ones', () {
    final stats = RatingStats(
      [
        record(today, reframe: {'a': 3}),
        // The first day of the 28-day window still counts as recent.
        record(today.addDays(-27), reframe: {'a': 4}),
        record(today.addDays(-28), reframe: {'a': 1}),
        record(today.addDays(-60), reframe: {'a': 2}),
      ],
      library: library,
      today: today,
    );
    final a = stats.of(RubricKind.reframe).single;
    expect(a.criterion.id, 'a');
    expect(a.recentCount, 2);
    expect(a.recentAverage, 3.5);
    expect(a.earlierCount, 2);
    expect(a.earlierAverage, 1.5);
    expect(a.count, 4);
  });

  test('keeps the two rubric kinds apart and skips unrated criteria', () {
    final stats = RatingStats(
      [
        record(today, reframe: {'b': 2}, phrases: {'a': 4}),
        record(today, subject: 'two', reframe: {'x': 3}),
      ],
      library: library,
      today: today,
    );
    expect(
      [for (final s in stats.of(RubricKind.reframe)) s.criterion.id],
      ['b', 'x'],
    );
    final phrases = stats.of(RubricKind.phrases).single;
    expect(phrases.criterion.id, 'a');
    expect(phrases.recentAverage, 4);
    expect(phrases.earlierAverage, isNull);
  });

  test('ignores ratings for criteria no longer in the content', () {
    final stats = RatingStats(
      [
        record(today, reframe: {'retired': 4}),
      ],
      library: library,
      today: today,
    );
    expect(stats.of(RubricKind.reframe), isEmpty);
  });

  test('the window edge goes by local day, even for records saved in UTC', () {
    PracticeRecord at(DateTime local, int rating) => PracticeRecord(
      scenarioId: 'one-1',
      subjectId: 'one',
      startedAt: local.toUtc(),
      finishedAt: local.toUtc(),
      reframes: RoundRecord(ratings: {'a': rating}),
    );
    final stats = RatingStats(
      [
        // First and last minute of the window's first day: recent.
        at(DateTime(2026, 10, 14, 0, 0), 4),
        at(DateTime(2026, 10, 14, 23, 59), 4),
        // Last minute of the day before: earlier.
        at(DateTime(2026, 10, 13, 23, 59), 1),
      ],
      library: library,
      today: today,
    );
    final a = stats.of(RubricKind.reframe).single;
    expect(a.recentCount, 2);
    expect(a.earlierCount, 1);
  });

  test('nothing practised gives nothing', () {
    expect(
      RatingStats(
        const [],
        library: library,
        today: today,
      ).of(RubricKind.phrases),
      isEmpty,
    );
  });
}
