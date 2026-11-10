import 'dart:convert';

import 'content_format_exception.dart';
import 'content_library.dart';
import 'content_source.dart';
import 'json_fields.dart';
import 'rubric.dart';
import 'rubric_kind.dart';
import 'scale_level.dart';
import 'scenario.dart';
import 'subject.dart';

/// Reads `library.json` and each subject's scenario file through [read],
/// which returns a file's text by name (from app assets, or disk in tests).
/// The format is described in `docs/content/README.md`.
class JsonContentSource implements ContentSource {
  JsonContentSource(this.read, {this.libraryFile = 'library.json'});

  /// The schema version this code understands.
  static const schemaVersion = 1;

  final Future<String> Function(String name) read;
  final String libraryFile;

  @override
  Future<ContentLibrary> load() async {
    final library = _document(await read(libraryFile), libraryFile);
    final scaleItems = library.list('scale');
    final scale = [
      for (var i = 0; i < scaleItems.length; i++)
        ScaleLevel.fromJson(
          JsonFields(scaleItems[i], '$libraryFile.scale[$i]'),
        ),
    ];
    if (scale.isEmpty) throw ContentFormatException('The scale is empty');
    final rubricsJson = library.object('rubrics');
    final rubrics = {
      for (final kind in RubricKind.values)
        kind: Rubric.fromJson(rubricsJson.object(kind.wireId)),
    };
    final subjectItems = library.list('subjects');
    final subjects = [
      for (var i = 0; i < subjectItems.length; i++)
        Subject.fromJson(
          JsonFields(subjectItems[i], '$libraryFile.subjects[$i]'),
        ),
    ];
    final scenarios = <Scenario>[];
    for (final subject in subjects) {
      scenarios.addAll(await _scenariosOf(subject));
    }
    if (scenarios.map((s) => s.id).toSet().length != scenarios.length) {
      throw ContentFormatException('Two scenarios share an id');
    }
    return ContentLibrary(
      scale: scale,
      rubrics: rubrics,
      subjects: subjects,
      scenarios: scenarios,
    );
  }

  Future<List<Scenario>> _scenariosOf(Subject subject) async {
    final name = subject.scenarioFile;
    final file = _document(await read(name), name);
    final owner = file.string('subjectId');
    if (owner != subject.id) {
      throw ContentFormatException('$name is for $owner, not ${subject.id}');
    }
    final items = file.list('scenarios');
    return [
      for (var i = 0; i < items.length; i++)
        Scenario.fromJson(
          JsonFields(items[i], '$name.scenarios[$i]'),
          subjectId: subject.id,
        ),
    ];
  }

  JsonFields _document(String text, String name) {
    final Object? json;
    try {
      json = jsonDecode(text);
    } on FormatException catch (e) {
      throw ContentFormatException('$name is not JSON: ${e.message}');
    }
    final fields = JsonFields(json, name);
    final version = fields.integer('schemaVersion');
    if (version != schemaVersion) {
      throw ContentFormatException(
        '$name has schema version $version; this app reads $schemaVersion',
      );
    }
    return fields;
  }
}
