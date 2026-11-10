import 'json_fields.dart';

/// One step on the self-rating scale, as "3 · Solid".
class ScaleLevel {
  const ScaleLevel(this.value, this.label);

  factory ScaleLevel.fromJson(JsonFields json) =>
      ScaleLevel(json.integer('value'), json.string('label'));

  final int value;
  final String label;
}
