import 'json_fields.dart';
import 'roleplay.dart';

/// One small situation to practise on.
class Scenario {
  const Scenario({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.setting,
    required this.difficulty,
    required this.situation,
    required this.firstThought,
    required this.reframes,
    required this.phrases,
    required this.roleplay,
    required this.takeaway,
  });

  factory Scenario.fromJson(JsonFields json, {required String subjectId}) =>
      Scenario(
        id: json.string('id'),
        subjectId: subjectId,
        title: json.string('title'),
        setting: json.string('setting'),
        difficulty: json.integer('difficulty').clamp(1, 3),
        situation: json.string('situation'),
        firstThought: json.string('firstThought'),
        reframes: json.strings('reframes'),
        phrases: json.strings('phrases'),
        roleplay: Roleplay.fromJson(json.object('roleplay')),
        takeaway: json.string('takeaway'),
      );

  /// Unique across all subjects, as "lg-03". Saved records refer to it.
  final String id;
  final String subjectId;
  final String title;

  /// The domain and place, as "Work · stand-up meeting".
  final String setting;

  /// 1 (easy) to 3 (hard).
  final int difficulty;

  /// What happens, in the second person.
  final String situation;

  /// The defensive, automatic thought the user might start with.
  final String firstThought;

  /// Suggested new ways to think about it.
  final List<String> reframes;

  /// Suggested things to say.
  final List<String> phrases;

  final Roleplay roleplay;

  /// One sentence to carry into the day.
  final String takeaway;
}
