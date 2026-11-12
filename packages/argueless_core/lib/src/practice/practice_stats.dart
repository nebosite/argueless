import '../time/local_day.dart';
import 'practice_record.dart';

/// Encouraging numbers from the practice log, as of [today].
class PracticeStats {
  PracticeStats(List<PracticeRecord> records, {required this.today})
    : _records = records;

  final List<PracticeRecord> _records;
  final LocalDay today;

  late final Set<LocalDay> _days = {
    for (final r in _records) LocalDay.of(r.finishedAt),
  };

  /// Days in a row with at least one practice, ending today. A streak that
  /// ended yesterday still counts until today is over.
  int get streak {
    var day = _days.contains(today) ? today : today.addDays(-1);
    var count = 0;
    while (_days.contains(day)) {
      count++;
      day = day.addDays(-1);
    }
    return count;
  }

  List<PracticeRecord> get _todays => [
    for (final r in _records)
      if (LocalDay.of(r.finishedAt) == today) r,
  ];

  int get practisedToday => _todays.length;

  /// Minutes spent practising today, rounded to the nearest minute.
  int get minutesToday {
    final total = _todays.fold(Duration.zero, (sum, r) => sum + r.duration);
    return (total.inSeconds / 60).round();
  }

  /// Ideas written in today's practices.
  int get ideasToday => _todays.fold(0, (sum, r) => sum + r.ideaCount);

  /// Every idea the user has written, across all practices.
  int get totalIdeas => _records.fold(0, (sum, r) => sum + r.ideaCount);

  int get totalPractices => _records.length;

  int practisedIn(String subjectId) =>
      _records.where((r) => r.subjectId == subjectId).length;
}
