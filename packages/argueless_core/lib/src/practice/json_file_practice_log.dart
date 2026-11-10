import 'dart:io';

import '../storage/atomic_json_file.dart';
import 'practice_log.dart';
import 'practice_record.dart';

/// Keeps the practice log in one JSON file:
/// `{"schemaVersion": 1, "records": [...]}`.
///
/// An entry that cannot be read is skipped but kept in the file, so a newer
/// app's records survive an older app adding to the log.
class JsonFilePracticeLog implements PracticeLog {
  JsonFilePracticeLog(File file)
    : _file = AtomicJsonFile(file, understands: _understands);

  static const schemaVersion = 1;

  final AtomicJsonFile _file;

  @override
  Future<List<PracticeRecord>> all() async {
    final records = <PracticeRecord>[];
    for (final entry in _entries(await _file.read())) {
      try {
        records.add(PracticeRecord.fromJson(entry as Map<String, dynamic>));
      } catch (_) {
        // Unreadable entries stay in the file but are not shown.
      }
    }
    records.sort((a, b) => a.finishedAt.compareTo(b.finishedAt));
    return records;
  }

  @override
  Future<void> add(PracticeRecord record) => _file.update(
    (current) => {
      'schemaVersion': schemaVersion,
      'records': [..._entries(current), record.toJson()],
    },
  );

  /// Our layout at a schema this code knows; anything else is set aside
  /// rather than overwritten.
  static bool _understands(Object? document) =>
      document is Map &&
      document['records'] is List &&
      (document['schemaVersion'] ?? schemaVersion) is int &&
      (document['schemaVersion'] ?? schemaVersion) as int <= schemaVersion;

  static List<Object?> _entries(Object? document) =>
      document is Map && document['records'] is List
      ? document['records'] as List<Object?>
      : const [];
}
