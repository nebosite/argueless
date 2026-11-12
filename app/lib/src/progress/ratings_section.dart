import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import 'criterion_bar.dart';

/// How the user has been rating themselves, criterion by criterion, for
/// reframes and for phrases.
class RatingsSection extends StatelessWidget {
  const RatingsSection({super.key, required this.stats, required this.scale});

  final RatingStats stats;
  final List<ScaleLevel> scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groups = [
      ('Reframes', stats.of(RubricKind.reframe)),
      ('Phrases', stats.of(RubricKind.phrases)),
    ];
    final rated = groups.any((g) => g.$2.isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'How you rate yourself',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          rated
              ? 'Your own ratings, in your own words. The bar is the last '
                    '4 weeks; once there are a few ratings, a thin line shows '
                    'where you were before. Ups and downs are normal.'
              : 'Your self-ratings from each practice will show here.',
          style: theme.textTheme.bodyMedium,
        ),
        for (final (title, criteria) in groups)
          if (criteria.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
            for (final c in criteria) CriterionBar(stats: c, scale: scale),
          ],
      ],
    );
  }
}
