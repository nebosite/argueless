import '../content/content_library.dart';
import '../content/scenario.dart';
import 'practice_log.dart';
import 'scenario_picker.dart';
import 'scenario_provider.dart';

/// Picks the next scenario from the shipped library, using the practice
/// log so the user meets new situations first.
class LibraryScenarioProvider implements ScenarioProvider {
  LibraryScenarioProvider(this.library, this.log, {ScenarioPicker? picker})
    : _picker = picker ?? ScenarioPicker();

  final ContentLibrary library;
  final PracticeLog log;
  final ScenarioPicker _picker;

  @override
  Future<Scenario?> next({String? subjectId, String? excluding}) async =>
      _picker.next(
        library,
        await log.all(),
        subjectId: subjectId,
        excluding: excluding,
      );
}
