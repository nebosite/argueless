/// When the daily reminder comes next. It repeats every day from then on.
class ReminderPlan {
  const ReminderPlan._();

  /// The first reminder at [hour]:[minute] local time after [now]: today if
  /// that time is still ahead, else tomorrow. A day already practised gets
  /// no reminder, so after a practice it starts tomorrow.
  static DateTime first({
    required DateTime now,
    required int hour,
    required int minute,
    required bool practisedToday,
  }) {
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    if (!practisedToday && today.isAfter(now)) return today;
    // Built from the date, not by adding 24 hours, so a clock change
    // overnight keeps the time.
    return DateTime(now.year, now.month, now.day + 1, hour, minute);
  }
}
