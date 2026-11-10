import 'dart:io';

import 'package:argueless_core/argueless_core.dart';

/// Where the app keeps its files, all in app-private storage.
class AppFiles {
  const AppFiles(this.documents);

  final Directory documents;

  File _file(String name) =>
      File('${documents.path}${Platform.pathSeparator}$name');

  JsonFilePracticeLog practiceLog() =>
      JsonFilePracticeLog(_file('practice_log.json'));

  JsonFileReflectionLog reflectionLog() =>
      JsonFileReflectionLog(_file('reflections.json'));
}
