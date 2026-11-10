/// A calendar day in the user's own time zone, with no time of day.
class LocalDay implements Comparable<LocalDay> {
  const LocalDay(this.year, this.month, this.day);

  /// The local day [moment] falls on.
  factory LocalDay.of(DateTime moment) {
    final local = moment.toLocal();
    return LocalDay(local.year, local.month, local.day);
  }

  /// Reads the `yyyy-mm-dd` form written by [toJson].
  factory LocalDay.parse(String text) {
    final parts = text.split('-');
    if (parts.length != 3) {
      throw FormatException('Not a day: $text');
    }
    return LocalDay(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  final int year;
  final int month;
  final int day;

  /// Noon on this day, so adding days never trips over a daylight-saving
  /// change.
  DateTime get _noon => DateTime(year, month, day, 12);

  LocalDay addDays(int days) => LocalDay.of(_noon.add(Duration(days: days)));

  /// Whole days from [other] to this day (negative if [other] is later).
  int daysSince(LocalDay other) =>
      (_noon.difference(other._noon).inHours / 24).round();

  /// Monday of this day's week.
  LocalDay get weekStart => addDays(1 - _noon.weekday);

  bool isBefore(LocalDay other) => compareTo(other) < 0;
  bool isAfter(LocalDay other) => compareTo(other) > 0;

  @override
  int compareTo(LocalDay other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDay &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  String toJson() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}'
      '-${day.toString().padLeft(2, '0')}';

  @override
  String toString() => toJson();
}
