/// The phone's notification system, as far as the daily reminder needs it.
abstract interface class ReminderScheduler {
  /// The reminder's words: fixed, and never anything the user wrote.
  static const title = 'A few quiet minutes?';
  static const body = 'Practise if you like, or just look back on your day.';

  /// Asks the user for permission to notify; true if granted, false if
  /// refused or it could not be asked.
  Future<bool> requestPermission();

  /// Whether notifications are allowed. Throws if the phone could not be
  /// asked, so a glitch is never mistaken for a refusal.
  Future<bool> hasPermission();

  /// One reminder a day at [first]'s time of day, the first at [first],
  /// replacing any earlier. Throws if it could not be scheduled.
  Future<void> scheduleDaily(DateTime first);

  /// Cancels the reminder.
  Future<void> cancel();
}
