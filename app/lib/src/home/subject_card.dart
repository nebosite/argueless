import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';
import '../app/subject_look.dart';

/// One subject on the home screen: tap to practise it.
class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subject,
    required this.practised,
    required this.total,
    required this.onTap,
  });

  final Subject subject;

  /// Practices finished in this subject (replays count).
  final int practised;

  /// Scenarios the subject has.
  final int total;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = SubjectLook.color(subject);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 6)),
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    ArguelessTheme.radius / 1.5,
                  ),
                ),
                child: Icon(SubjectLook.icon(subject), color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(subject.tagline, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(
                      practised == 0
                          ? '$total scenarios to explore'
                          : 'Practised $practised × · $total scenarios',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
