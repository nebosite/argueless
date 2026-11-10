import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';
import '../app/subject_look.dart';

/// The celebration at the end of a practice, with the takeaway.
class FinishView extends StatelessWidget {
  const FinishView({
    super.key,
    required this.scenario,
    required this.subject,
    required this.record,
    required this.stats,
    required this.onAnother,
    required this.onHome,
  });

  final Scenario scenario;
  final Subject subject;
  final PracticeRecord record;
  final PracticeStats stats;
  final VoidCallback onAnother;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = SubjectLook.color(subject);
    final minutes = stats.minutesToday;
    return ListView(
      padding: const EdgeInsets.all(ArguelessTheme.gutter),
      children: [
        const SizedBox(height: 12),
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.3, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: ArguelessTheme.sunshine,
              child: const Icon(
                Icons.celebration_rounded,
                size: 52,
                color: Color(0xFF3D1E00),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Nicely done!',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${record.ideaCount} ideas of your own · '
          '${stats.streak} day streak · $minutes min today',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(ArguelessTheme.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TAKE THIS WITH YOU',
                style: theme.textTheme.labelMedium?.copyWith(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                scenario.takeaway,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (record.favourite case final favourite?) ...[
                const SizedBox(height: 12),
                Text('Your phrase: "$favourite"'),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (minutes < 15)
          FilledButton(
            onPressed: onAnother,
            child: Text(
              minutes < 5 ? 'Another scenario' : 'One more, if you like',
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(64, 52)),
          onPressed: onHome,
          child: const Text('Done for now'),
        ),
      ],
    );
  }
}
