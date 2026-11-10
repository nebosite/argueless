import 'package:argueless_core/argueless_core.dart';

/// A practice log in memory.
class MemoryPracticeLog implements PracticeLog {
  MemoryPracticeLog([List<PracticeRecord>? records]) : records = records ?? [];

  final List<PracticeRecord> records;

  @override
  Future<List<PracticeRecord>> all() async => [...records];

  @override
  Future<void> add(PracticeRecord record) async => records.add(record);
}
