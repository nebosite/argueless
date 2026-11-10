import 'package:flutter/material.dart';

import 'chart_colors.dart';

/// Names the chart's three colours, so identity is never colour alone.
class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key, required this.colors});

  final ChartColors colors;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    Widget item(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: style),
      ],
    );
    return Wrap(
      spacing: 16,
      runSpacing: 6,
      children: [
        item(colors.automatic, 'Generous right away'),
        item(colors.recovered, 'Turned around'),
        item(colors.conflict, 'Conflict'),
      ],
    );
  }
}
