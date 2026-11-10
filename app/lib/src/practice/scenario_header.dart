import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';
import '../app/subject_look.dart';

/// The situation and the defensive first thought, shown at the top of each
/// step. When [collapsed] it shows only the title until tapped.
class ScenarioHeader extends StatefulWidget {
  const ScenarioHeader({
    super.key,
    required this.scenario,
    required this.subject,
    this.collapsed = false,
  });

  final Scenario scenario;
  final Subject subject;
  final bool collapsed;

  @override
  State<ScenarioHeader> createState() => _ScenarioHeaderState();
}

class _ScenarioHeaderState extends State<ScenarioHeader> {
  late bool _open = !widget.collapsed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = SubjectLook.color(widget.subject);
    final s = widget.scenario;
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(ArguelessTheme.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(ArguelessTheme.radius),
        onTap: () => setState(() => _open = !_open),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      s.setting.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Difficulty ${s.difficulty} of 3',
                    excludeSemantics: true,
                    child: Row(
                      children: [
                        for (var i = 1; i <= 3; i++)
                          Icon(
                            Icons.bolt_rounded,
                            size: 18,
                            color: i <= s.difficulty
                                ? color
                                : color.withValues(alpha: 0.25),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    _open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                s.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (_open) ...[
                const SizedBox(height: 8),
                Text(s.situation, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.psychology_alt_rounded, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'First thought: "${s.firstThought}"',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
