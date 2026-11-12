import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../speech/dictation_button.dart';
import '../speech/speech_input.dart';
import 'idea_cheer.dart';
import 'step_layout.dart';

/// Brainstorm as many ideas as possible, one bullet at a time, typed or
/// spoken. The keyboard stays closed until the user taps the field.
class BrainstormStep extends StatefulWidget {
  const BrainstormStep({
    super.key,
    required this.header,
    required this.round,
    required this.prompt,
    required this.hint,
    required this.explainer,
    required this.speech,
    required this.onChanged,
    required this.onContinue,
  });

  final Widget header;
  final BrainstormRound round;
  final String prompt;
  final String hint;
  final String explainer;
  final SpeechInput speech;
  final VoidCallback onChanged;
  final VoidCallback onContinue;

  @override
  State<BrainstormStep> createState() => _BrainstormStepState();
}

class _BrainstormStepState extends State<BrainstormStep> {
  final _field = TextEditingController();
  final _focus = FocusNode();
  late final List<String> _ideas = [...widget.round.ideas];

  @override
  void dispose() {
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _sync() {
    widget.round.ideas = [..._ideas, _field.text];
    widget.onChanged();
  }

  void _add() {
    final text = _field.text.replaceAll('\n', ' ').trim();
    if (text.isEmpty) return;
    setState(() {
      _ideas.add(text);
      _field.clear();
    });
    _sync();
  }

  void _remove(int i) {
    setState(() => _ideas.removeAt(i));
    _sync();
  }

  void _continue() {
    // A half-typed idea counts.
    _add();
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = widget.round.ideas.length;
    return StepLayout(
      buttonLabel: 'Show me suggestions',
      buttonHint: 'Write at least one idea to see the suggestions.',
      onPressed: widget.round.hasIdeas ? _continue : null,
      children: [
        widget.header,
        const SizedBox(height: 20),
        Text(
          widget.prompt,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(widget.explainer, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        for (final (i, idea) in _ideas.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(idea, style: theme.textTheme.bodyLarge)),
                IconButton(
                  tooltip: 'Remove "$idea"',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => _remove(i),
                ),
              ],
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ideaField()),
            const SizedBox(width: 8),
            DictationButton(
              speech: widget.speech,
              controller: _field,
              onChanged: (_) => _sync(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        IdeaCheer(count: count),
      ],
    );
  }

  Widget _ideaField() => TextField(
    key: const Key('idea-field'),
    controller: _field,
    focusNode: _focus,
    textCapitalization: TextCapitalization.sentences,
    // Single-line input that still wraps: Enter adds the idea.
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.done,
    minLines: 1,
    maxLines: 3,
    decoration: InputDecoration(
      hintText: widget.hint,
      suffixIcon: IconButton(
        tooltip: 'Add idea',
        icon: const Icon(Icons.add_circle_rounded),
        onPressed: _add,
      ),
    ),
    onChanged: (_) => _sync(),
    onSubmitted: (_) {
      _add();
      // Enter closes the keyboard; keep it open for the next idea.
      _focus.requestFocus();
    },
  );
}
