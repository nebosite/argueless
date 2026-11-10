import '../content/content_library.dart';
import '../content/rubric_kind.dart';
import '../content/scenario.dart';
import 'brainstorm_round.dart';
import 'practice_record.dart';
import 'practice_step.dart';

/// One practice on one scenario, moving through [PracticeStep]s.
///
/// Each step must be complete before [advance] moves on: at least one idea
/// in a brainstorm, every criterion rated in a review, and a favourite
/// phrase and a reply in the role-play.
class PracticeSession {
  PracticeSession({
    required this.scenario,
    required ContentLibrary library,
    required this.startedAt,
  }) : reframes = BrainstormRound(
         kind: RubricKind.reframe,
         rubric: library.rubricFor(scenario.subjectId, RubricKind.reframe),
         suggestions: scenario.reframes,
       ),
       phrases = BrainstormRound(
         kind: RubricKind.phrases,
         rubric: library.rubricFor(scenario.subjectId, RubricKind.phrases),
         suggestions: scenario.phrases,
       );

  final Scenario scenario;
  final DateTime startedAt;
  final BrainstormRound reframes;
  final BrainstormRound phrases;

  PracticeStep _step = PracticeStep.reframes;
  PracticeStep get step => _step;

  String? _favourite;

  /// The phrase chosen for the role-play.
  String? get favourite => _favourite;

  String _reply = '';

  /// What the user says in the role-play.
  String get reply => _reply;
  set reply(String value) => _reply = value.trim();

  /// The phrases to choose a favourite from: the user's own, then the
  /// suggestions they liked. If there are none, every suggestion.
  List<String> get favouriteChoices {
    final mine = [...phrases.ideas, ...phrases.liked];
    final unique = <String>{...mine}.toList();
    return unique.isEmpty ? scenario.phrases : unique;
  }

  void chooseFavourite(String phrase) {
    if (!favouriteChoices.contains(phrase)) {
      throw ArgumentError.value(phrase, 'phrase', 'not one of the choices');
    }
    _favourite = phrase;
    if (_reply.isEmpty) _reply = phrase;
  }

  bool get canAdvance => switch (_step) {
    PracticeStep.reframes => reframes.hasIdeas,
    PracticeStep.reframeReview => reframes.isRated,
    PracticeStep.phrases => phrases.hasIdeas,
    PracticeStep.phraseReview => phrases.isRated,
    PracticeStep.roleplay => _favourite != null && _reply.isNotEmpty,
    PracticeStep.done => false,
  };

  void advance() {
    if (!canAdvance) {
      throw StateError('The ${_step.name} step is not complete');
    }
    _step = _step.next;
  }

  /// The record to save, once the practice is [PracticeStep.done].
  PracticeRecord record({required DateTime finishedAt}) {
    if (_step != PracticeStep.done) {
      throw StateError('The practice is not finished');
    }
    return PracticeRecord(
      scenarioId: scenario.id,
      subjectId: scenario.subjectId,
      startedAt: startedAt,
      finishedAt: finishedAt,
      reframes: reframes.toRecord(),
      phrases: phrases.toRecord(),
      favourite: _favourite,
      reply: _reply,
    );
  }
}
