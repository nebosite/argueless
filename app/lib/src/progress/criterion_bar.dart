import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

/// One rubric criterion: the user's average self-rating as a bar on the
/// rating scale, in words rather than scores, with a thin mark where it
/// stood before once there are enough ratings to compare.
class CriterionBar extends StatelessWidget {
  const CriterionBar({super.key, required this.stats, required this.scale});

  /// Ratings needed on each side before a comparison is shown: one hard
  /// day is not a trend.
  static const enoughToCompare = 3;

  final CriterionStats stats;
  final List<ScaleLevel> scale;

  /// The scale word nearest [average].
  String _word(double average) {
    var best = scale.first;
    for (final level in scale) {
      if ((level.value - average).abs() < (best.value - average).abs()) {
        best = level;
      }
    }
    return best.label;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final max = scale.map((l) => l.value).reduce((a, b) => a > b ? a : b);
    final recent = stats.recentAverage;
    // Only older ratings: show those, muted, without a "before" mark.
    final stale = recent == null;
    final shown = recent ?? stats.earlierAverage!;
    final before =
        stats.recentCount >= enoughToCompare &&
            stats.earlierCount >= enoughToCompare
        ? stats.earlierAverage
        : null;
    final count = stats.recentCount;
    final detail = stale
        ? 'Last rated over 4 weeks ago'
        : '$count ${count == 1 ? 'rating' : 'ratings'} lately'
              '${before == null ? '' : ' · before: ${_word(before)}'}';
    return Semantics(
      label: '${stats.criterion.label}: ${_word(shown)}. $detail.',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    stats.criterion.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  _word(shown),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 12,
              child: LayoutBuilder(
                builder: (context, box) {
                  final width = box.maxWidth;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Container(
                        width: width * (shown / max).clamp(0, 1),
                        decoration: BoxDecoration(
                          color: stale ? scheme.outline : scheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      if (before != null)
                        Positioned(
                          left: (width * (before / max).clamp(0, 1) - 1.5)
                              .clamp(0, width - 3),
                          top: -3,
                          bottom: -3,
                          child: Container(
                            key: const Key('before-mark'),
                            width: 3,
                            decoration: BoxDecoration(
                              color: scheme.onSurface,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Text(detail, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
