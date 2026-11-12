import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import 'rubric_rater.dart';
import 'step_layout.dart';
import 'suggestion_tile.dart';

/// The user's ideas beside the suggested ones, then a self-rating.
class ReviewStep extends StatelessWidget {
  const ReviewStep({
    super.key,
    required this.header,
    required this.round,
    required this.scale,
    required this.suggestionsTitle,
    required this.heartHint,
    required this.onChanged,
    required this.onContinue,
  });

  final Widget header;
  final BrainstormRound round;
  final List<ScaleLevel> scale;
  final String suggestionsTitle;

  /// What tapping a heart means here.
  final String heartHint;
  final VoidCallback onChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heading = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w800,
    );
    return StepLayout(
      buttonLabel: 'Next',
      buttonHint: 'Rate yourself on each line to go on.',
      onPressed: round.isRated ? onContinue : null,
      children: [
        header,
        const SizedBox(height: 20),
        Text('Yours (${round.ideas.length})', style: heading),
        const SizedBox(height: 6),
        for (final idea in round.ideas)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Icon(
                    Icons.circle,
                    size: 8,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(idea, style: theme.textTheme.bodyLarge)),
              ],
            ),
          ),
        const SizedBox(height: 20),
        Text(suggestionsTitle, style: heading),
        Text(heartHint, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final (i, suggestion) in round.suggestions.indexed)
          SuggestionTile(
            text: suggestion,
            liked: round.isLiked(i),
            onToggle: () {
              round.toggleLiked(i);
              onChanged();
            },
          ),
        const SizedBox(height: 20),
        RubricRater(
          rubric: round.rubric,
          scale: scale,
          ratingOf: round.rating,
          onRate: (id, value) {
            round.rate(id, value);
            onChanged();
          },
        ),
      ],
    );
  }
}
