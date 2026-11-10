import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import 'chat_bubble.dart';
import 'step_layout.dart';

/// Pick a favourite phrase, then use it: the other person speaks, the user
/// replies (ideally out loud first), and the other person answers.
class RoleplayStep extends StatefulWidget {
  const RoleplayStep({
    super.key,
    required this.session,
    required this.onChanged,
    required this.onContinue,
  });

  final PracticeSession session;
  final VoidCallback onChanged;
  final VoidCallback onContinue;

  @override
  State<RoleplayStep> createState() => _RoleplayStepState();
}

class _RoleplayStepState extends State<RoleplayStep> {
  final _reply = TextEditingController();
  bool _sent = false;

  PracticeSession get _session => widget.session;

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  void _choose(String phrase) {
    // Replace the reply only if the user has not made it their own.
    final untouched =
        _reply.text.trim().isEmpty || _reply.text == _session.favourite;
    _session.chooseFavourite(phrase);
    if (!_sent && untouched) _reply.text = phrase;
    _session.reply = _reply.text;
    widget.onChanged();
  }

  void _send() {
    _session.reply = _reply.text;
    if (_session.reply.isEmpty) return;
    setState(() => _sent = true);
    FocusManager.instance.primaryFocus?.unfocus();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roleplay = _session.scenario.roleplay;
    final heading = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
    );
    return StepLayout(
      buttonLabel: 'Finish',
      buttonHint: _session.favourite == null
          ? 'Pick your favourite phrase first.'
          : 'Send your reply to finish.',
      onPressed: _sent && _session.canAdvance ? widget.onContinue : null,
      children: [
        Text('Pick your favourite', style: heading),
        const SizedBox(height: 4),
        Text(
          'Which phrase would you most like to have ready?',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        for (final phrase in _session.favouriteChoices)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: phrase == _session.favourite
                ? theme.colorScheme.primaryContainer
                : null,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(phrase),
              selected: phrase == _session.favourite,
              trailing: phrase == _session.favourite
                  ? const Icon(Icons.star_rounded)
                  : const Icon(Icons.star_border_rounded),
              onTap: _sent ? null : () => _choose(phrase),
            ),
          ),
        if (_session.favourite != null) ...[
          const SizedBox(height: 16),
          Text('Role-play', style: heading),
          const SizedBox(height: 4),
          Text(
            'You are with ${roleplay.partner}. Read their line, then say '
            'your reply out loud before you send it. Make it your own.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          ChatBubble(
            speaker: roleplay.partnerName,
            text: roleplay.opening,
            mine: false,
          ),
          if (_sent) ...[
            ChatBubble(speaker: 'You', text: _session.reply, mine: true),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, t, child) => Opacity(opacity: t, child: child),
              child: ChatBubble(
                speaker: roleplay.partnerName,
                text: roleplay.partnerReply,
                mine: false,
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            TextField(
              key: const Key('reply-field'),
              controller: _reply,
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Your reply…'),
              onChanged: (text) {
                _session.reply = text;
                widget.onChanged();
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                key: const Key('send-reply'),
                onPressed: _session.reply.isEmpty ? null : _send,
                icon: const Icon(Icons.send_rounded),
                label: const Text('I said it. Send'),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
