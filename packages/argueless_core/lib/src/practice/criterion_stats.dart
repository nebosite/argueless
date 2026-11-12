import '../content/rubric_criterion.dart';
import '../content/rubric_kind.dart';

/// How the user has rated themselves on one criterion: lately, and before.
class CriterionStats {
  const CriterionStats({
    required this.kind,
    required this.criterion,
    required this.recentCount,
    required this.recentAverage,
    required this.earlierCount,
    required this.earlierAverage,
  });

  final RubricKind kind;
  final RubricCriterion criterion;

  /// Ratings in the recent window, and their average (null if none).
  final int recentCount;
  final double? recentAverage;

  /// Ratings before the recent window, and their average (null if none).
  final int earlierCount;
  final double? earlierAverage;

  int get count => recentCount + earlierCount;
}
