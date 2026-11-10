import 'json_fields.dart';

/// One thing the user rates themselves on, as "Curious: My ideas wonder
/// what I might not know yet."
class RubricCriterion {
  const RubricCriterion({
    required this.id,
    required this.label,
    required this.prompt,
  });

  factory RubricCriterion.fromJson(JsonFields json) => RubricCriterion(
    id: json.string('id'),
    label: json.string('label'),
    prompt: json.string('prompt'),
  );

  final String id;
  final String label;
  final String prompt;
}
