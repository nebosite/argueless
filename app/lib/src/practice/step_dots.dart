import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

/// How far through the practice the user is: one bar per step.
class StepDots extends StatelessWidget {
  const StepDots({super.key, required this.step});

  final PracticeStep step;

  static const _steps = [
    PracticeStep.reframes,
    PracticeStep.reframeReview,
    PracticeStep.phrases,
    PracticeStep.phraseReview,
    PracticeStep.roleplay,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final at = _steps.indexOf(step);
    return Semantics(
      label: 'Step ${at + 1} of ${_steps.length}',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            for (var i = 0; i < _steps.length; i++)
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i <= at
                        ? scheme.primary
                        : scheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
