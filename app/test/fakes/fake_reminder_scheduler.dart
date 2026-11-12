import 'package:argueless/src/reminders/reminder_scheduler.dart';

/// Records what the app asks of the notification system.
class FakeReminderScheduler implements ReminderScheduler {
  FakeReminderScheduler({this.granted = true});

  /// Whether notifications are allowed.
  bool granted;

  /// What a permission request answers.
  bool grantOnRequest = true;

  /// The phone cannot say whether notifications are allowed.
  bool checkFails = false;

  /// Scheduling fails.
  bool scheduleFails = false;

  final List<String> calls = [];

  /// The first reminder of the daily schedule, or null if none.
  DateTime? scheduled;

  @override
  Future<bool> requestPermission() async {
    calls.add('request');
    granted = grantOnRequest;
    return granted;
  }

  @override
  Future<bool> hasPermission() async {
    if (checkFails) throw StateError('plugin not ready');
    return granted;
  }

  @override
  Future<void> scheduleDaily(DateTime first) async {
    calls.add('schedule');
    if (scheduleFails) throw StateError('could not schedule');
    scheduled = first;
  }

  @override
  Future<void> cancel() async {
    calls.add('cancel');
    scheduled = null;
  }
}
