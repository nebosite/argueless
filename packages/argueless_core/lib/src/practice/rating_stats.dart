import '../content/content_library.dart';
import '../content/rubric_kind.dart';
import '../time/local_day.dart';
import 'criterion_stats.dart';
import 'practice_record.dart';
import 'round_record.dart';

/// The user's self-ratings from the practice log, by rubric criterion: the
/// last [recentDays] days against everything before.
class RatingStats {
  RatingStats(
    this._records, {
    required this.library,
    required this.today,
    this.recentDays = 28,
  });

  final List<PracticeRecord> _records;
  final ContentLibrary library;
  final LocalDay today;
  final int recentDays;

  LocalDay get _recentStart => today.addDays(1 - recentDays);

  /// Every criterion of [kind] the user has rated, in rubric order. Ratings
  /// on a criterion no longer in the content are left out.
  List<CriterionStats> of(RubricKind kind) => [
    for (final criterion in library.criteriaFor(kind))
      if (_ratings(kind, criterion.id) case (
        final recent,
        final earlier,
      ) when recent.isNotEmpty || earlier.isNotEmpty)
        CriterionStats(
          kind: kind,
          criterion: criterion,
          recentCount: recent.length,
          recentAverage: _average(recent),
          earlierCount: earlier.length,
          earlierAverage: _average(earlier),
        ),
  ];

  /// The ratings for criterion [id], split into (recent, earlier).
  (List<int>, List<int>) _ratings(RubricKind kind, String id) {
    final recent = <int>[];
    final earlier = <int>[];
    for (final record in _records) {
      final rating = _round(record, kind).ratings[id];
      if (rating == null) continue;
      final day = LocalDay.of(record.finishedAt);
      (day.isBefore(_recentStart) ? earlier : recent).add(rating);
    }
    return (recent, earlier);
  }

  static RoundRecord _round(PracticeRecord record, RubricKind kind) =>
      switch (kind) {
        RubricKind.reframe => record.reframes,
        RubricKind.phrases => record.phrases,
      };

  static double? _average(List<int> values) =>
      values.isEmpty ? null : values.reduce((a, b) => a + b) / values.length;
}
