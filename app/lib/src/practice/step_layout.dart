import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';

/// A practice step: scrolling content above one big button pinned to the
/// bottom.
class StepLayout extends StatelessWidget {
  const StepLayout({
    super.key,
    required this.children,
    required this.buttonLabel,
    required this.onPressed,
    this.buttonHint,
  });

  final List<Widget> children;
  final String buttonLabel;

  /// Null disables the button.
  final VoidCallback? onPressed;

  /// Shown above the button while it is disabled, saying what is missing.
  final String? buttonHint;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            ArguelessTheme.gutter,
            8,
            ArguelessTheme.gutter,
            24,
          ),
          children: children,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(
          ArguelessTheme.gutter,
          0,
          ArguelessTheme.gutter,
          12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (onPressed == null && buttonHint != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  buttonHint!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
          ],
        ),
      ),
    ],
  );
}
