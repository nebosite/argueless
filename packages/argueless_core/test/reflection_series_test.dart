import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

void main() {
  // Tuesday 10 November 2026.
  const end = LocalDay(2026, 11, 10);

  final series = ReflectionSeries(const [
    Reflection(day: LocalDay(2026, 10, 1), automatic: 9),
    Reflection(day: LocalDay(2026, 11, 2), automatic: 1, conflict: 1),
    Reflection(day: LocalDay(2026, 11, 9), automatic: 2, recovered: 1),
    Reflection(day: end, recovered: 2, conflict: 2),
  ]);

  test('daily buckets end today, oldest first, gaps included', () {
    final days = series.daily(end: end, count: 3);
    expect(days.map((b) => b.start), [
      const LocalDay(2026, 11, 8),
      const LocalDay(2026, 11, 9),
      end,
    ]);
    expect(days[0].total, 0);
    expect(days[0].generousShare, isNull);
    expect(days[1].generousShare, 1);
    expect(days[2].generousShare, 0.5);
  });

  test('weekly buckets run Monday to Sunday and add up', () {
    final weeks = series.weekly(end: end, count: 2);
    expect(weeks.map((b) => b.start), [
      const LocalDay(2026, 11, 2),
      const LocalDay(2026, 11, 9),
    ]);
    expect(weeks[0].automatic, 1);
    expect(weeks[0].conflict, 1);
    expect(weeks[1].automatic, 2);
    expect(weeks[1].recovered, 3);
    expect(weeks[1].conflict, 2);
    expect(weeks[1].reflections, 2);
  });

  test('LocalDay arithmetic crosses months and daylight saving', () {
    expect(const LocalDay(2026, 3, 1).addDays(-1), const LocalDay(2026, 2, 28));
    expect(
      const LocalDay(2026, 11, 2).daysSince(const LocalDay(2026, 10, 30)),
      3,
    );
    expect(const LocalDay(2026, 3, 8).addDays(1), const LocalDay(2026, 3, 9));
    expect(LocalDay.parse(end.toJson()), end);
    expect(end.weekStart, const LocalDay(2026, 11, 9));
  });
}
