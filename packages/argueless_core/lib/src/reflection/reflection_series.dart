import '../time/local_day.dart';
import 'reflection.dart';
import 'reflection_bucket.dart';

/// Turns reflections into evenly spaced buckets, oldest first, for the
/// progress chart. Empty days and weeks are included, so gaps show.
class ReflectionSeries {
  const ReflectionSeries(this.reflections);

  final List<Reflection> reflections;

  /// One bucket per day for the [count] days ending on [end].
  List<ReflectionBucket> daily({required LocalDay end, int count = 14}) =>
      _buckets(first: end.addDays(1 - count), size: 1, count: count);

  /// One bucket per Monday-to-Sunday week for the [count] weeks ending with
  /// the week holding [end].
  List<ReflectionBucket> weekly({required LocalDay end, int count = 12}) =>
      _buckets(
        first: end.weekStart.addDays(-7 * (count - 1)),
        size: 7,
        count: count,
      );

  List<ReflectionBucket> _buckets({
    required LocalDay first,
    required int size,
    required int count,
  }) {
    final sums = List.generate(count, (_) => [0, 0, 0, 0]);
    for (final r in reflections) {
      final offset = r.day.daysSince(first);
      if (offset < 0) continue;
      final i = offset ~/ size;
      if (i >= count) continue;
      sums[i][0] += r.automatic;
      sums[i][1] += r.recovered;
      sums[i][2] += r.conflict;
      sums[i][3] += 1;
    }
    return [
      for (var i = 0; i < count; i++)
        ReflectionBucket(
          start: first.addDays(i * size),
          days: size,
          automatic: sums[i][0],
          recovered: sums[i][1],
          conflict: sums[i][2],
          reflections: sums[i][3],
        ),
    ];
  }
}
