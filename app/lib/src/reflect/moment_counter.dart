import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';

/// One kind of moment with a count the user steps up and down. It reports
/// steps (+1 or -1), not new values, so taps faster than frames all count.
class MomentCounter extends StatelessWidget {
  const MomentCounter({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onStep,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final int value;
  final ValueChanged<int> onStep;

  static const max = 99;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ArguelessTheme.radius),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          IconButton(
            tooltip: 'One fewer',
            icon: const Icon(Icons.remove_circle_outline_rounded),
            onPressed: value > 0 ? () => onStep(-1) : null,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              semanticsLabel: '$title: $value',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            tooltip: 'One more',
            icon: const Icon(Icons.add_circle_rounded),
            color: color,
            onPressed: value < max ? () => onStep(1) : null,
          ),
        ],
      ),
    );
  }
}
