import '../time/local_day.dart';

/// The user's look back over the last 24 hours, saved on [day]: how many
/// tricky moments went each way.
class Reflection {
  const Reflection({
    required this.day,
    this.automatic = 0,
    this.recovered = 0,
    this.conflict = 0,
  }) : assert(automatic >= 0 && recovered >= 0 && conflict >= 0);

  /// Throws if [json] is not a reflection (the log skips it).
  factory Reflection.fromJson(Map<String, dynamic> json) => Reflection(
    day: LocalDay.parse(json['day'] as String),
    automatic: json['automatic'] as int? ?? 0,
    recovered: json['recovered'] as int? ?? 0,
    conflict: json['conflict'] as int? ?? 0,
  );

  final LocalDay day;

  /// Moments where generous thinking came automatically.
  final int automatic;

  /// Moments that started defensive but turned generous before replying.
  final int recovered;

  /// Moments that turned into conflict.
  final int conflict;

  int get total => automatic + recovered + conflict;

  /// The share of moments that went generously (automatic or recovered),
  /// or null if there were none.
  double? get generousShare =>
      total == 0 ? null : (automatic + recovered) / total;

  Reflection copyWith({int? automatic, int? recovered, int? conflict}) =>
      Reflection(
        day: day,
        automatic: automatic ?? this.automatic,
        recovered: recovered ?? this.recovered,
        conflict: conflict ?? this.conflict,
      );

  Map<String, dynamic> toJson() => {
    'day': day.toJson(),
    'automatic': automatic,
    'recovered': recovered,
    'conflict': conflict,
  };
}
