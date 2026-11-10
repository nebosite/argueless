import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';

/// The self-rating card: one row of scale choices per criterion.
class RubricRater extends StatelessWidget {
  const RubricRater({
    super.key,
    required this.rubric,
    required this.scale,
    required this.ratingOf,
    required this.onRate,
  });

  final Rubric rubric;
  final List<ScaleLevel> scale;
  final int? Function(String criterionId) ratingOf;
  final void Function(String criterionId, int value) onRate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ArguelessTheme.sunshine.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(ArguelessTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rubric.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'Be honest and kind with yourself. This is practice.',
            style: theme.textTheme.bodySmall,
          ),
          for (final criterion in rubric.criteria) ...[
            const SizedBox(height: 14),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${criterion.label}  ',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: criterion.prompt),
                ],
              ),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final level in scale)
                  ChoiceChip(
                    key: Key('rate-${criterion.id}-${level.value}'),
                    label: Text(level.label),
                    // Compact, so the whole scale fits on one line.
                    showCheckmark: false,
                    visualDensity: VisualDensity.compact,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                    selected: ratingOf(criterion.id) == level.value,
                    onSelected: (_) => onRate(criterion.id, level.value),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
