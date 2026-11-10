import 'dart:math';

import '../content/content_library.dart';
import '../content/scenario.dart';
import 'practice_record.dart';

/// Chooses what to practise next from a static library.
///
/// Without a subject it picks the subject practised least, so all four get
/// attention. Within a subject it prefers scenarios never played, then the
/// one played longest ago. Ties are broken at random.
class ScenarioPicker {
  ScenarioPicker({Random? random}) : _random = random ?? Random();

  final Random _random;

  Scenario? next(
    ContentLibrary library,
    List<PracticeRecord> history, {
    String? subjectId,
    String? excluding,
  }) {
    final subject = subjectId ?? _leastPractisedSubject(library, history);
    if (subject == null) return null;
    final candidates = [
      for (final s in library.scenariosFor(subject))
        if (s.id != excluding) s,
    ];
    if (candidates.isEmpty) return null;
    final lastPlayed = <String, DateTime>{
      for (final r in history) r.scenarioId: r.finishedAt,
    };
    final fresh = [
      for (final s in candidates)
        if (!lastPlayed.containsKey(s.id)) s,
    ];
    if (fresh.isNotEmpty) return fresh[_random.nextInt(fresh.length)];
    candidates.sort((a, b) => lastPlayed[a.id]!.compareTo(lastPlayed[b.id]!));
    return candidates.first;
  }

  String? _leastPractisedSubject(
    ContentLibrary library,
    List<PracticeRecord> history,
  ) {
    final playable = [
      for (final s in library.subjects)
        if (library.scenariosFor(s.id).isNotEmpty) s.id,
    ];
    if (playable.isEmpty) return null;
    final counts = {for (final id in playable) id: 0};
    for (final r in history) {
      if (counts.containsKey(r.subjectId)) {
        counts[r.subjectId] = counts[r.subjectId]! + 1;
      }
    }
    final fewest = counts.values.reduce(min);
    final least = [
      for (final e in counts.entries)
        if (e.value == fewest) e.key,
    ];
    return least[_random.nextInt(least.length)];
  }
}
