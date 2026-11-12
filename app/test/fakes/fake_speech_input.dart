import 'package:argueless/src/speech/speech_input.dart';

/// Speech recognition the test drives: [say] words, then [finish].
class FakeSpeechInput implements SpeechInput {
  FakeSpeechInput({this.available = true});

  /// Whether listening can start.
  bool available;

  void Function(String words)? _onWords;
  void Function()? _onStopped;

  bool get isListening => _onStopped != null;

  @override
  Future<bool> listen({
    required void Function(String words) onWords,
    required void Function() onStopped,
  }) async {
    if (!available) return false;
    _onWords = onWords;
    _onStopped = onStopped;
    return true;
  }

  /// Everything heard so far in this session.
  void say(String words) => _onWords?.call(words);

  /// Listening ends on its own.
  void finish() {
    final stopped = _onStopped;
    _onWords = null;
    _onStopped = null;
    stopped?.call();
  }

  @override
  Future<void> stop() async => finish();
}
