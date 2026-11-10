import '../content/json_fields.dart';
import '../time/local_day.dart';
import 'app_version.dart';

/// What changed in one version.
class ReleaseNote {
  const ReleaseNote({
    required this.version,
    required this.date,
    required this.changes,
  });

  factory ReleaseNote.fromJson(JsonFields json) => ReleaseNote(
    version: AppVersion.parse(json.string('version')),
    date: LocalDay.parse(json.string('date')),
    changes: json.strings('changes'),
  );

  final AppVersion version;

  /// The day the version was finished.
  final LocalDay date;

  /// One plain sentence per change, for the user to read.
  final List<String> changes;
}
