import 'package:flutter/material.dart';

/// Every idea the user has written, as a small light-bulb badge.
class IdeaChip extends StatelessWidget {
  const IdeaChip({super.key, required this.ideas});

  final int ideas;

  @override
  Widget build(BuildContext context) {
    // Nothing written yet is not news.
    if (ideas == 0) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final label = ideas == 1 ? '1 idea' : '$ideas ideas';
    return Semantics(
      label: '$label written so far',
      excludeSemantics: true,
      child: Container(
        key: const Key('idea-chip'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.secondaryContainer,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lightbulb_rounded,
              size: 20,
              color: scheme.onSecondaryContainer,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: scheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
