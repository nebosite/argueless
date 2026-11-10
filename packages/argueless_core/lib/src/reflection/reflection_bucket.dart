import '../time/local_day.dart';

/// Reflections added up over a run of days (one day, or one week) for the
/// progress chart.
class ReflectionBucket {
  const ReflectionBucket({
    required this.start,
    required this.days,
    this.automatic = 0,
    this.recovered = 0,
    this.conflict = 0,
    this.reflections = 0,
  });

  /// The first day in the bucket.
  final LocalDay start;

  /// How many days the bucket spans.
  final int days;

  final int automatic;
  final int recovered;
  final int conflict;

  /// How many days in the bucket had a reflection saved.
  final int reflections;

  int get total => automatic + recovered + conflict;

  /// The share of moments that went generously, or null with no moments.
  double? get generousShare =>
      total == 0 ? null : (automatic + recovered) / total;
}
