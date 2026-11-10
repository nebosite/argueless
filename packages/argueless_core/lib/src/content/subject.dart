import 'json_fields.dart';
import 'rubric.dart';
import 'rubric_kind.dart';

/// One of the practice themes, such as "Letting go of being right".
class Subject {
  const Subject({
    required this.id,
    required this.title,
    required this.tagline,
    required this.brief,
    required this.color,
    required this.icon,
    required this.scenarioFile,
    this.rubrics = const {},
  });

  factory Subject.fromJson(JsonFields json) {
    final rubrics = <RubricKind, Rubric>{};
    if (json.has('rubrics')) {
      final overrides = json.object('rubrics');
      for (final kind in RubricKind.values) {
        if (overrides.has(kind.wireId)) {
          rubrics[kind] = Rubric.fromJson(overrides.object(kind.wireId));
        }
      }
    }
    return Subject(
      id: json.string('id'),
      title: json.string('title'),
      tagline: json.string('tagline'),
      brief: json.string('brief'),
      color: int.parse(json.string('color')),
      icon: json.string('icon'),
      scenarioFile: json.string('scenarioFile'),
      rubrics: rubrics,
    );
  }

  final String id;
  final String title;

  /// A short, playful line under the title.
  final String tagline;

  /// What the subject practises, in a sentence or two.
  final String brief;

  /// ARGB colour for the subject's cards.
  final int color;

  /// A Material icon name, mapped to an icon by the app.
  final String icon;

  /// The content file holding this subject's scenarios.
  final String scenarioFile;

  /// Rubrics that replace the library's for this subject only.
  final Map<RubricKind, Rubric> rubrics;
}
