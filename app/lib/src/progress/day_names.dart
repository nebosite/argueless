import 'package:argueless_core/argueless_core.dart';

/// Short English day labels, without a locale package.
class DayNames {
  const DayNames._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  /// "10 Nov".
  static String short(LocalDay day) => '${day.day} ${_months[day.month - 1]}';

  /// "Tue 10 Nov".
  static String long(LocalDay day) {
    final weekday = DateTime(day.year, day.month, day.day).weekday;
    return '${_weekdays[weekday - 1]} ${short(day)}';
  }
}
