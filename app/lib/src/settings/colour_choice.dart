import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';

/// A labelled, wrapping group of colour swatches; the chosen one has a ring
/// and a tick.
class ColourChoice extends StatelessWidget {
  const ColourChoice({
    super.key,
    required this.label,
    required this.colours,
    required this.value,
    required this.onChanged,
  });

  final String label;

  /// ARGB values, from [AppPalette].
  final List<int> colours;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ArguelessTheme.gutter,
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final colour in colours)
                _swatch(theme, colour, colour == value),
            ],
          ),
        ],
      ),
    );
  }

  Widget _swatch(ThemeData theme, int value, bool chosen) {
    final colour = Color(value);
    final name = AppPalette.names[value] ?? '';
    final tick = ThemeData.estimateBrightnessForColor(colour) == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Tooltip(
      message: name,
      child: Semantics(
        button: true,
        selected: chosen,
        label: name,
        // The tap is given again here: excluding the child's semantics
        // would otherwise drop it.
        onTap: () => onChanged(value),
        excludeSemantics: true,
        child: InkResponse(
          onTap: () => onChanged(value),
          radius: 24,
          // 48 dp to tap, 32 dp to see.
          child: SizedBox(
            width: ArguelessTheme.tapTarget,
            height: ArguelessTheme.tapTarget,
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colour,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: chosen
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.outline,
                    width: chosen ? 2 : 1,
                  ),
                ),
                child: chosen
                    ? Icon(Icons.check_rounded, size: 20, color: tick)
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
