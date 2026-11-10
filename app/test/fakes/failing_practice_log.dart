import 'dart:io';

import 'package:argueless_core/argueless_core.dart';

import 'memory_practice_log.dart';

/// A practice log whose next [failures] adds throw, as a full disk would.
class FailingPracticeLog extends MemoryPracticeLog {
  FailingPracticeLog({this.failures = 1});

  int failures;

  @override
  Future<void> add(PracticeRecord record) async {
    if (failures > 0) {
      failures--;
      throw const FileSystemException('No space left on device');
    }
    await super.add(record);
  }
}
