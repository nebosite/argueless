import '../content/scenario.dart';

/// Decides which scenario the user practises next. Today it picks from the
/// shipped library (`LibraryScenarioProvider`); a generator could write a
/// fresh one instead.
abstract interface class ScenarioProvider {
  /// A scenario in [subjectId] (any subject if null), other than
  /// [excluding]; null if there is nothing to offer.
  Future<Scenario?> next({String? subjectId, String? excluding});
}
