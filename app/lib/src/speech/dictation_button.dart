import 'package:flutter/material.dart';

import 'speech_input.dart';

/// A microphone button that types what the user says into [controller],
/// after any text already there. Tapping it again stops listening. Once the
/// user edits the text by hand, late words from the recognizer are dropped
/// rather than overwriting the edit.
class DictationButton extends StatefulWidget {
  const DictationButton({
    super.key,
    required this.speech,
    required this.controller,
    this.onChanged,
  });

  final SpeechInput speech;
  final TextEditingController controller;

  /// Called after each change to the text.
  final ValueChanged<String>? onChanged;

  @override
  State<DictationButton> createState() => _DictationButtonState();
}

class _DictationButtonState extends State<DictationButton> {
  bool _listening = false;
  bool _gone = false;

  @override
  void dispose() {
    // Stopping calls onStopped back synchronously; no setState from here.
    _gone = true;
    if (_listening) widget.speech.stop();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_listening) {
      setState(() => _listening = false);
      await widget.speech.stop();
      return;
    }
    // Close the keyboard while speaking: it would cover the words.
    FocusManager.instance.primaryFocus?.unfocus();
    final before = widget.controller.text.trimRight();
    final prefix = before.isEmpty ? '' : '$before ';
    var written = widget.controller.text;
    setState(() => _listening = true);
    final started = await widget.speech.listen(
      onWords: (words) {
        // Gone, or edited by hand since the last words arrived.
        if (!mounted || _gone || widget.controller.text != written) return;
        final text = '$prefix$words';
        written = text;
        widget.controller.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
        widget.onChanged?.call(text);
      },
      onStopped: () {
        if (mounted && !_gone) setState(() => _listening = false);
      },
    );
    if (started || !mounted) return;
    setState(() => _listening = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Couldn't start listening. Check that ArgueLess may use the "
          "microphone in your phone's settings, and that the phone has "
          'speech recognition.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton.filledTonal(
      key: const Key('mic'),
      tooltip: _listening ? 'Stop listening' : 'Speak instead of typing',
      isSelected: _listening,
      style: IconButton.styleFrom(
        backgroundColor: _listening ? scheme.primary : null,
        foregroundColor: _listening ? scheme.onPrimary : null,
      ),
      icon: Icon(_listening ? Icons.mic_rounded : Icons.mic_none_rounded),
      onPressed: _toggle,
    );
  }
}
