import '../time/local_day.dart';
import 'reflection.dart';

/// Where daily reflections are kept: at most one per day.
abstract interface class ReflectionLog {
  /// Every readable reflection, oldest day first.
  Future<List<Reflection>> all();

  /// The reflection saved on [day], if any.
  Future<Reflection?> on(LocalDay day);

  /// Saves [reflection], replacing any other saved on the same day.
  Future<void> save(Reflection reflection);
}
