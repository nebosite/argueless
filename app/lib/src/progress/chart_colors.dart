import 'package:flutter/material.dart';

/// The reflection chart's three series colours, chosen per brightness and
/// checked for colour-blind separation (aqua, blue, orange). The light aqua
/// is under 3:1 on the surface, so the chart always has a legend and a
/// tap-for-numbers line.
class ChartColors {
  const ChartColors._(this.automatic, this.recovered, this.conflict);

  final Color automatic;
  final Color recovered;
  final Color conflict;

  static const light = ChartColors._(
    Color(0xFF1BAF7A),
    Color(0xFF2A78D6),
    Color(0xFFEB6834),
  );

  static const dark = ChartColors._(
    Color(0xFF199E70),
    Color(0xFF3987E5),
    Color(0xFFD95926),
  );

  static ChartColors of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}
