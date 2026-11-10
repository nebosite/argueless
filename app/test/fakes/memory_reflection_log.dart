import 'package:argueless_core/argueless_core.dart';

/// A reflection log in memory.
class MemoryReflectionLog implements ReflectionLog {
  MemoryReflectionLog([List<Reflection>? reflections])
    : reflections = reflections ?? [];

  final List<Reflection> reflections;

  @override
  Future<List<Reflection>> all() async =>
      [...reflections]..sort((a, b) => a.day.compareTo(b.day));

  @override
  Future<Reflection?> on(LocalDay day) async {
    for (final r in reflections) {
      if (r.day == day) return r;
    }
    return null;
  }

  @override
  Future<void> save(Reflection reflection) async {
    reflections
      ..removeWhere((r) => r.day == reflection.day)
      ..add(reflection);
  }
}
