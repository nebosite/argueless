import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';

/// Days in a row practised, as a small flame badge.
class StreakChip extends StatelessWidget {
  const StreakChip({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    // No streak is not news: show nothing rather than "0 days".
    if (days == 0) return const SizedBox.shrink();
    final label = days == 1 ? '1 day' : '$days days';
    return Semantics(
      label: 'Streak: $label in a row',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: ArguelessTheme.sunshine,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              size: 20,
              color: Color(0xFF7A3B00),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF3D1E00),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
