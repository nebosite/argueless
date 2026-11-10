import 'round_record.dart';

/// One finished practice, as saved in the practice log.
class PracticeRecord {
  const PracticeRecord({
    required this.scenarioId,
    required this.subjectId,
    required this.startedAt,
    required this.finishedAt,
    this.reframes = const RoundRecord(),
    this.phrases = const RoundRecord(),
    this.favourite,
    this.reply = '',
  });

  /// Throws if [json] is not a record (the log skips it).
  factory PracticeRecord.fromJson(Map<String, dynamic> json) => PracticeRecord(
    scenarioId: json['scenarioId'] as String,
    subjectId: json['subjectId'] as String,
    startedAt: DateTime.parse(json['startedAt'] as String),
    finishedAt: DateTime.parse(json['finishedAt'] as String),
    reframes: RoundRecord.fromJson(
      json['reframes'] as Map<String, dynamic>? ?? const {},
    ),
    phrases: RoundRecord.fromJson(
      json['phrases'] as Map<String, dynamic>? ?? const {},
    ),
    favourite: json['favourite'] as String?,
    reply: json['reply'] as String? ?? '',
  );

  final String scenarioId;
  final String subjectId;
  final DateTime startedAt;
  final DateTime finishedAt;
  final RoundRecord reframes;
  final RoundRecord phrases;

  /// The phrase the user chose for the role-play.
  final String? favourite;

  /// What the user said in the role-play.
  final String reply;

  /// The user's own ideas across both brainstorms.
  int get ideaCount => reframes.ideas.length + phrases.ideas.length;

  Duration get duration => finishedAt.difference(startedAt);

  Map<String, dynamic> toJson() => {
    'scenarioId': scenarioId,
    'subjectId': subjectId,
    'startedAt': startedAt.toUtc().toIso8601String(),
    'finishedAt': finishedAt.toUtc().toIso8601String(),
    'reframes': reframes.toJson(),
    'phrases': phrases.toJson(),
    if (favourite != null) 'favourite': favourite,
    'reply': reply,
  };
}
