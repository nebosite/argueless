import 'rubric.dart';
import 'rubric_criterion.dart';
import 'rubric_kind.dart';
import 'scale_level.dart';
import 'scenario.dart';
import 'subject.dart';

/// Everything there is to practise: the subjects, their scenarios, and the
/// rubrics and scale the user rates themselves with.
class ContentLibrary {
  ContentLibrary({
    required this.scale,
    required Map<RubricKind, Rubric> rubrics,
    required this.subjects,
    required List<Scenario> scenarios,
  }) : _rubrics = rubrics,
       _scenarios = {for (final s in scenarios) s.id: s};

  final List<ScaleLevel> scale;
  final Map<RubricKind, Rubric> _rubrics;
  final List<Subject> subjects;
  final Map<String, Scenario> _scenarios;

  Iterable<Scenario> get scenarios => _scenarios.values;

  Subject? subject(String id) {
    for (final s in subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  Scenario? scenario(String id) => _scenarios[id];

  List<Scenario> scenariosFor(String subjectId) => [
    for (final s in _scenarios.values)
      if (s.subjectId == subjectId) s,
  ];

  /// The subject's own rubric of [kind] if it has one, else the library's.
  Rubric rubricFor(String subjectId, RubricKind kind) =>
      subject(subjectId)?.rubrics[kind] ?? _rubrics[kind]!;

  /// Every criterion of [kind] in any rubric, once per id: the library's
  /// own first, then those only subjects add, in subject order.
  List<RubricCriterion> criteriaFor(RubricKind kind) {
    final byId = <String, RubricCriterion>{};
    for (final rubric in [
      _rubrics[kind]!,
      for (final s in subjects) ?s.rubrics[kind],
    ]) {
      for (final c in rubric.criteria) {
        byId.putIfAbsent(c.id, () => c);
      }
    }
    return byId.values.toList();
  }
}
