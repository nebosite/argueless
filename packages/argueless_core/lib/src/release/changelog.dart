import 'dart:convert';

import '../content/content_format_exception.dart';
import '../content/json_fields.dart';
import 'app_version.dart';
import 'release_note.dart';

/// Every version's notes, newest first, read from `changelog.json`:
/// `{"schemaVersion": 1, "versions": [{"version", "date", "changes"}]}`.
class Changelog {
  Changelog(this.notes) {
    if (notes.isEmpty) throw ContentFormatException('The changelog is empty');
    for (var i = 1; i < notes.length; i++) {
      if (notes[i].version.compareTo(notes[i - 1].version) >= 0) {
        throw ContentFormatException(
          'The changelog must list versions newest first, each once '
          '(${notes[i - 1].version} then ${notes[i].version})',
        );
      }
    }
  }

  factory Changelog.parse(String text) {
    final Object? json;
    try {
      json = jsonDecode(text);
    } on FormatException catch (e) {
      throw ContentFormatException('changelog.json is not JSON: ${e.message}');
    }
    final fields = JsonFields(json, 'changelog.json');
    final items = fields.list('versions');
    return Changelog([
      for (var i = 0; i < items.length; i++)
        ReleaseNote.fromJson(
          JsonFields(items[i], 'changelog.json.versions[$i]'),
        ),
    ]);
  }

  /// Newest first.
  final List<ReleaseNote> notes;

  /// The version this build is.
  AppVersion get current => notes.first.version;
}
