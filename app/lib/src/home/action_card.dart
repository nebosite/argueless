import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';

/// A big, friendly tappable card with an icon, a title and a line of text.
class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  /// Filled with [color] (the day's main action) rather than tinted.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = filled ? color : color.withValues(alpha: 0.14);
    // Filled: ink that reads on [color], which is light in dark mode.
    final ink = !filled
        ? theme.colorScheme.onSurface
        : ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(ArguelessTheme.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ArguelessTheme.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: filled
                    ? ink.withValues(alpha: 0.15)
                    : color.withValues(alpha: 0.3),
                child: Icon(icon, color: ink, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(color: ink),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: ink),
            ],
          ),
        ),
      ),
    );
  }
}
