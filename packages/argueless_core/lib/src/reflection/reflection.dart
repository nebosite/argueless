import '../time/local_day.dart';

/// The user's journal entry for [day]: free-form notes on what they noticed
/// over the last day.
///
/// Before 0.3.0 the reflection was three counts of tricky moments. Old
/// entries keep their counts, and saving writes them back, so nothing the
/// user recorded is lost; the app no longer asks for them.
class Reflection {
  const Reflection({
    required this.day,
    this.note = '',
    this.automatic = 0,
    this.recovered = 0,
    this.conflict = 0,
  }) : assert(automatic >= 0 && recovered >= 0 && conflict >= 0);

  /// Throws if [json] is not a reflection (the log skips it).
  factory Reflection.fromJson(Map<String, dynamic> json) => Reflection(
    day: LocalDay.parse(json['day'] as String),
    note: json['note'] is String ? json['note'] as String : '',
    automatic: json['automatic'] as int? ?? 0,
    recovered: json['recovered'] as int? ?? 0,
    conflict: json['conflict'] as int? ?? 0,
  );

  final LocalDay day;

  /// What the user wrote.
  final String note;

  /// Counts from before 0.3.0: moments that went generously at once...
  final int automatic;

  /// ...that started defensive but turned around...
  final int recovered;

  /// ...and that turned into conflict.
  final int conflict;

  /// Whether this is an entry from before 0.3.0 that only has counts.
  bool get hasOnlyCounts =>
      note.trim().isEmpty && automatic + recovered + conflict > 0;

  Reflection copyWith({String? note}) => Reflection(
    day: day,
    note: note ?? this.note,
    automatic: automatic,
    recovered: recovered,
    conflict: conflict,
  );

  Map<String, dynamic> toJson() => {
    'day': day.toJson(),
    'note': note,
    'automatic': automatic,
    'recovered': recovered,
    'conflict': conflict,
  };
}
