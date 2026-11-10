import 'content_format_exception.dart';
import 'json_fields.dart';
import 'rubric_criterion.dart';

/// What the user rates themselves on after one brainstorm.
class Rubric {
  const Rubric({required this.title, required this.criteria});

  factory Rubric.fromJson(JsonFields json) {
    final items = json.list('criteria');
    final criteria = [
      for (var i = 0; i < items.length; i++)
        RubricCriterion.fromJson(
          JsonFields(items[i], '${json.where}.criteria[$i]'),
        ),
    ];
    if (criteria.isEmpty) {
      throw ContentFormatException('${json.where} has no criteria');
    }
    if (criteria.map((c) => c.id).toSet().length != criteria.length) {
      throw ContentFormatException('${json.where} repeats a criterion id');
    }
    return Rubric(title: json.string('title'), criteria: criteria);
  }

  final String title;
  final List<RubricCriterion> criteria;
}
