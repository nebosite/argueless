import 'package:argueless_core/argueless_core.dart';

/// A small library for tests: two subjects, the second with its own reframe
/// rubric.
ContentLibrary testLibrary({int perSubject = 3}) {
  const rubric = Rubric(
    title: 'Rate',
    criteria: [
      RubricCriterion(id: 'a', label: 'A', prompt: 'a?'),
      RubricCriterion(id: 'b', label: 'B', prompt: 'b?'),
    ],
  );
  const special = Rubric(
    title: 'Special',
    criteria: [RubricCriterion(id: 'x', label: 'X', prompt: 'x?')],
  );
  return ContentLibrary(
    scale: const [ScaleLevel(1, 'Not yet'), ScaleLevel(4, 'Nailed it')],
    rubrics: const {RubricKind.reframe: rubric, RubricKind.phrases: rubric},
    subjects: const [
      Subject(
        id: 'one',
        title: 'One',
        tagline: 't',
        brief: 'b',
        color: 0xFF000000,
        icon: 'help',
        scenarioFile: 'one.json',
      ),
      Subject(
        id: 'two',
        title: 'Two',
        tagline: 't',
        brief: 'b',
        color: 0xFF000000,
        icon: 'help',
        scenarioFile: 'two.json',
        rubrics: {RubricKind.reframe: special},
      ),
    ],
    scenarios: [
      for (final subject in ['one', 'two'])
        for (var i = 1; i <= perSubject; i++)
          testScenario('$subject-$i', subject),
    ],
  );
}

Scenario testScenario(String id, String subjectId) => Scenario(
  id: id,
  subjectId: subjectId,
  title: 'Title $id',
  setting: 'Work · desk',
  difficulty: 2,
  situation: 'Something happens.',
  firstThought: 'Ugh.',
  reframes: const ['r1', 'r2', 'r3'],
  phrases: const ['p1', 'p2', 'p3'],
  roleplay: const Roleplay(
    partner: 'Dana, your manager',
    opening: 'Hi.',
    partnerReply: 'Oh, thanks.',
  ),
  takeaway: 'Be kind.',
);

PracticeRecord testRecord(
  String scenarioId,
  String subjectId,
  DateTime finishedAt, {
  Duration took = const Duration(minutes: 5),
  int ideas = 2,
}) => PracticeRecord(
  scenarioId: scenarioId,
  subjectId: subjectId,
  startedAt: finishedAt.subtract(took),
  finishedAt: finishedAt,
  reframes: RoundRecord(ideas: List.filled(ideas, 'idea')),
);
