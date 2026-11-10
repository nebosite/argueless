import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import 'chart_colors.dart';
import 'chart_legend.dart';
import 'day_names.dart';
import 'reflection_chart_painter.dart';

/// The progress chart: stacked bars of how moments went, a legend, and the
/// numbers for whichever bar is tapped (the latest with data to start).
class ReflectionChart extends StatefulWidget {
  const ReflectionChart({
    super.key,
    required this.buckets,
    required this.weekly,
  });

  final List<ReflectionBucket> buckets;

  /// Buckets are weeks rather than days.
  final bool weekly;

  @override
  State<ReflectionChart> createState() => _ReflectionChartState();
}

class _ReflectionChartState extends State<ReflectionChart> {
  int? _selected;

  int? get _shown {
    if (_selected case final i? when i < widget.buckets.length) return i;
    final latest = widget.buckets.lastIndexWhere((b) => b.reflections > 0);
    return latest < 0 ? null : latest;
  }

  @override
  void didUpdateWidget(ReflectionChart old) {
    super.didUpdateWidget(old);
    if (old.weekly != widget.weekly) _selected = null;
  }

  List<String?> get _labels {
    final n = widget.buckets.length;
    // About five labels, always including the newest.
    final every = (n / 5).ceil().clamp(1, n);
    return [
      for (var i = 0; i < n; i++)
        (n - 1 - i) % every == 0
            ? DayNames.short(widget.buckets[i].start)
            : null,
    ];
  }

  String _describe(ReflectionBucket b) {
    final when = widget.weekly
        ? 'Week of ${DayNames.short(b.start)}'
        : DayNames.long(b.start);
    if (b.reflections == 0) return '$when: no reflection saved.';
    return '$when: ${b.automatic} generous right away, ${b.recovered} '
        'turned around, ${b.conflict} conflict.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = ChartColors.of(context);
    final shown = _shown;
    final withData = widget.buckets.where((b) => b.reflections > 0).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChartLegend(colors: colors),
        const SizedBox(height: 12),
        Semantics(
          label:
              'Chart of moments per ${widget.weekly ? 'week' : 'day'}, '
              '$withData with reflections. Tap a bar for its numbers.',
          child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) => setState(
                () => _selected = ReflectionChartPainter.indexAt(
                  details.localPosition.dx,
                  constraints.maxWidth,
                  widget.buckets.length,
                ),
              ),
              child: CustomPaint(
                size: Size(constraints.maxWidth, 200),
                painter: ReflectionChartPainter(
                  buckets: widget.buckets,
                  labels: _labels,
                  colors: colors,
                  ink: theme.colorScheme.onSurfaceVariant,
                  grid: theme.colorScheme.outlineVariant,
                  selected: shown,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          shown == null
              ? 'No reflections in this range yet.'
              : _describe(widget.buckets[shown]),
          key: const Key('chart-detail'),
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
