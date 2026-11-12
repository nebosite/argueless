import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'speech_input.dart';

/// Speech recognition through the phone's own speech service (on Android,
/// the same one the keyboard's microphone uses). The app never sees the
/// audio, only the words.
///
/// The plugin reports one session's end more than once ("notListening",
/// then "done"), and its final words can arrive after the first of those.
/// Each session is numbered so a late signal reaches only its own caller.
class PhoneSpeechInput implements SpeechInput {
  final _speech = SpeechToText();
  bool _ready = false;
  int _session = 0;
  void Function()? _onStopped;

  /// Whether the current session has started listening; end signals from
  /// before that belong to the previous session.
  bool _live = false;

  Future<bool> _init() async {
    if (_ready) return true;
    try {
      _ready = await _speech.initialize(
        onStatus: (status) {
          if (status == SpeechToText.listeningStatus) {
            _live = true;
          } else if (_live &&
              (status == SpeechToText.doneStatus ||
                  status == SpeechToText.notListeningStatus)) {
            _stopped();
          }
        },
        // Error codes only (as "error_no_match"), never the words.
        onError: (error) {
          debugPrint('ArgueLess: speech error: ${error.errorMsg}');
          _stopped();
        },
        options: [SpeechToText.androidNoBluetooth],
      );
    } catch (e) {
      debugPrint('ArgueLess: speech unavailable: ${e.runtimeType}');
      _ready = false;
    }
    return _ready;
  }

  /// Tells the current session's caller, once, that listening ended.
  void _stopped() {
    _live = false;
    final stopped = _onStopped;
    _onStopped = null;
    stopped?.call();
  }

  @override
  Future<bool> listen({
    required void Function(String words) onWords,
    required void Function() onStopped,
  }) async {
    if (!await _init()) return false;
    // A new session ends the old one, and the old one's late words are
    // dropped.
    _stopped();
    final session = ++_session;
    _onStopped = onStopped;
    try {
      await _speech.listen(
        onResult: (result) {
          if (session == _session) onWords(result.recognizedWords);
        },
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          partialResults: true,
          cancelOnError: true,
          autoPunctuation: true,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('ArgueLess: speech listen failed: ${e.runtimeType}');
      if (session == _session) _onStopped = null;
      return false;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _speech.stop();
    } catch (e) {
      debugPrint('ArgueLess: speech stop failed: ${e.runtimeType}');
    }
    _stopped();
  }
}
