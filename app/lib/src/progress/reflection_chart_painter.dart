import 'dart:math';

import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import 'chart_colors.dart';

/// Draws reflection buckets as stacked bars: generous-right-away at the
/// bottom, then turned-around, then conflict, with a surface gap between
/// segments and a rounded top. Recessive grid lines at 0, half and max.
class ReflectionChartPainter extends CustomPainter {
  ReflectionChartPainter({
    required this.buckets,
    required this.labels,
    required this.colors,
    required this.ink,
    required this.grid,
    this.selected,
  });

  final List<ReflectionBucket> buckets;

  /// An x-axis label per bucket; null for none.
  final List<String?> labels;
  final ChartColors colors;
  final Color ink;
  final Color grid;
  final int? selected;

  static const axisWidth = 28.0;
  static const labelHeight = 22.0;
  static const _gap = 2.0;

  /// The top of the scale: the biggest total, rounded up to an even number
  /// so the half line is whole, and at least 4.
  int get scaleMax {
    final most = buckets.fold(0, (m, b) => max(m, b.total));
    return max(4, most + most % 2);
  }

  /// The bar index under [dx], or null.
  static int? indexAt(double dx, double width, int count) {
    final plot = width - axisWidth;
    if (dx < axisWidth || count == 0) return null;
    return min(count - 1, ((dx - axisWidth) / plot * count).floor());
  }

  @override
  void paint(Canvas canvas, Size size) {
    final plotHeight = size.height - labelHeight;
    final plotWidth = size.width - axisWidth;
    final top = scaleMax;
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final value in [0, top ~/ 2, top]) {
      final y = plotHeight - value / top * plotHeight;
      canvas.drawLine(Offset(axisWidth, y), Offset(size.width, y), gridPaint);
      _text(canvas, '$value', Offset(axisWidth - 6, y), alignRight: true);
    }
    final slot = plotWidth / buckets.length;
    final barWidth = min(28.0, slot * 0.6);
    for (final (i, bucket) in buckets.indexed) {
      final left = axisWidth + slot * i + (slot - barWidth) / 2;
      if (i == selected) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(axisWidth + slot * i, 0, slot, plotHeight),
            const Radius.circular(6),
          ),
          Paint()..color = grid.withValues(alpha: 0.35),
        );
      }
      var base = plotHeight;
      final segments = [
        (bucket.automatic, colors.automatic),
        (bucket.recovered, colors.recovered),
        (bucket.conflict, colors.conflict),
      ].where((s) => s.$1 > 0).toList();
      for (final (j, (count, color)) in segments.indexed) {
        final height = count / top * plotHeight;
        final isTop = j == segments.length - 1;
        final rect = Rect.fromLTWH(
          left,
          base - height,
          barWidth,
          max(0, height - (j == 0 ? 0 : _gap)),
        );
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            rect,
            topLeft: Radius.circular(isTop ? 4 : 0),
            topRight: Radius.circular(isTop ? 4 : 0),
          ),
          Paint()..color = color,
        );
        base -= height;
      }
      final label = labels[i];
      if (label != null) {
        _text(
          canvas,
          label,
          Offset(left + barWidth / 2, plotHeight + labelHeight / 2 + 2),
          center: true,
        );
      }
    }
  }

  void _text(
    Canvas canvas,
    String text,
    Offset at, {
    bool alignRight = false,
    bool center = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: ink, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = alignRight
        ? at.dx - painter.width
        : center
        ? at.dx - painter.width / 2
        : at.dx;
    painter.paint(canvas, Offset(dx, at.dy - painter.height / 2));
  }

  @override
  bool shouldRepaint(ReflectionChartPainter old) =>
      old.buckets != buckets ||
      old.selected != selected ||
      old.colors != colors ||
      old.ink != ink;
}
