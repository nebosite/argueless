/// The steps of one practice, in order.
enum PracticeStep {
  /// Brainstorm new ways to think about the situation.
  reframes,

  /// Compare with the suggested reframes and rate yourself.
  reframeReview,

  /// Brainstorm things you could say.
  phrases,

  /// Compare with the suggested phrases and rate yourself.
  phraseReview,

  /// Pick a favourite phrase and use it in a short role-play.
  roleplay,

  /// Finished: the summary.
  done;

  PracticeStep get next => this == done ? done : PracticeStep.values[index + 1];
}
