/// The phone's speech recognition, behind a small interface so tests can
/// use a fake.
abstract interface class SpeechInput {
  /// Starts listening. [onWords] receives everything heard so far in this
  /// session, each call replacing the last; it may still be called with the
  /// final words shortly after [onStopped]. [onStopped] is called at most
  /// once, when listening ends or a new session starts.
  ///
  /// Returns false, without listening, if listening could not start: no
  /// speech recognition on the phone, or the microphone refused.
  Future<bool> listen({
    required void Function(String words) onWords,
    required void Function() onStopped,
  });

  /// Stops listening early, keeping what was heard.
  Future<void> stop();
}
