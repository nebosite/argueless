import 'dart:io';

import '../storage/atomic_json_file.dart';
import '../time/local_day.dart';
import 'reflection.dart';
import 'reflection_log.dart';

/// Keeps reflections in one JSON file:
/// `{"schemaVersion": 1, "reflections": [...]}`.
///
/// An entry that cannot be read is skipped but kept in the file.
class JsonFileReflectionLog implements ReflectionLog {
  JsonFileReflectionLog(File file)
    : _file = AtomicJsonFile(file, understands: _understands);

  static const schemaVersion = 1;

  final AtomicJsonFile _file;

  @override
  Future<List<Reflection>> all() async {
    final reflections = <Reflection>[];
    for (final entry in _entries(await _file.read())) {
      try {
        reflections.add(Reflection.fromJson(entry as Map<String, dynamic>));
      } catch (_) {
        // Unreadable entries stay in the file but are not shown.
      }
    }
    reflections.sort((a, b) => a.day.compareTo(b.day));
    return reflections;
  }

  @override
  Future<Reflection?> on(LocalDay day) async {
    for (final r in await all()) {
      if (r.day == day) return r;
    }
    return null;
  }

  @override
  Future<void> save(Reflection reflection) => _file.update(
    (current) => {
      'schemaVersion': schemaVersion,
      'reflections': [
        for (final entry in _entries(current))
          if (!_isDay(entry, reflection.day)) entry,
        reflection.toJson(),
      ],
    },
  );

  static bool _isDay(Object? entry, LocalDay day) =>
      entry is Map && entry['day'] == day.toJson();

  /// Our layout at a schema this code knows; anything else is set aside
  /// rather than overwritten.
  static bool _understands(Object? document) =>
      document is Map &&
      document['reflections'] is List &&
      (document['schemaVersion'] ?? schemaVersion) is int &&
      (document['schemaVersion'] ?? schemaVersion) as int <= schemaVersion;

  static List<Object?> _entries(Object? document) =>
      document is Map && document['reflections'] is List
      ? document['reflections'] as List<Object?>
      : const [];
}
