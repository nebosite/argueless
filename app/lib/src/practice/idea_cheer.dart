import 'package:flutter/material.dart';

/// A little cheer that grows with the number of ideas, so quantity feels
/// like a game.
class IdeaCheer extends StatelessWidget {
  const IdeaCheer({super.key, required this.count});

  final int count;

  static String textFor(int count) => switch (count) {
    0 => 'Anything goes. Quantity beats quality here.',
    1 => '1 idea. Nice start!',
    2 || 3 => '$count ideas. Keep going!',
    4 || 5 => '$count ideas. On a roll!',
    _ => '$count ideas. Idea machine!',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            count >= 4 ? Icons.auto_awesome_rounded : Icons.lightbulb_rounded,
            key: ValueKey(count >= 4),
            color: theme.colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            textFor(count),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
