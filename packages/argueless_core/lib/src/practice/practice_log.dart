import 'practice_record.dart';

/// Where finished practices are kept.
abstract interface class PracticeLog {
  /// Every readable record, oldest first.
  Future<List<PracticeRecord>> all();

  Future<void> add(PracticeRecord record);
}
