import 'dart:async';

import 'package:argueless_core/argueless_core.dart';

import '../app/clock.dart';
import 'reminder_scheduler.dart';
import 'reminder_settings_store.dart';

/// What happened when the user turned reminders on.
enum EnableResult { enabled, denied }

/// Keeps the daily reminder in step with the user's setting and their
/// practice: a day already practised gets no reminder. Every change runs
/// one at a time.
class ReminderCoordinator {
  ReminderCoordinator({
    required this.scheduler,
    required this.store,
    required this.practiceLog,
    this.clock = const Clock(),
  });

  final ReminderScheduler scheduler;
  final ReminderSettingsStore store;
  final PracticeLog practiceLog;
  final Clock clock;

  Future<void> _tail = Future.value();

  Future<T> _serial<T>(Future<T> Function() step) {
    final result = _tail.then((_) => step());
    _tail = result.then((_) {}, onError: (_) {});
    return result;
  }

  Future<ReminderSettings> settings() => store.load();

  /// Brings the schedule up to date; run whenever home is shown, which
  /// includes coming back from a practice.
  Future<void> sync() => _serial(_sync);

  Future<void> _sync() async {
    final settings = await store.load();
    if (!settings.enabled) {
      await scheduler.cancel();
      return;
    }
    bool allowed;
    try {
      allowed = await scheduler.hasPermission();
    } catch (_) {
      // Could not tell: leave the setting and the schedule as they are.
      return;
    }
    if (!allowed) {
      // Permission was taken away in the phone's settings: switch off,
      // never ask again.
      await store.save(settings.copyWith(enabled: false));
      await scheduler.cancel();
      return;
    }
    final now = clock.now();
    var practisedToday = false;
    try {
      final today = LocalDay.of(now);
      practisedToday = (await practiceLog.all()).any(
        (r) => LocalDay.of(r.finishedAt) == today,
      );
    } catch (_) {
      // Can't tell: remind as usual.
    }
    await scheduler.scheduleDaily(
      ReminderPlan.first(
        now: now,
        hour: settings.hour,
        minute: settings.minute,
        practisedToday: practisedToday,
      ),
    );
  }

  /// Whether to offer reminders: only once, ever.
  Future<bool> shouldOffer() async => !await store.hasSaved();

  /// The user said "not now" to the offer; it is not made again.
  Future<void> decline() => _serial(() async {
    await store.save(await store.load());
  });

  /// Turns reminders on (asking permission) or off.
  Future<EnableResult> setEnabled(bool enabled) => _serial(() async {
    final settings = await store.load();
    if (enabled && !await _allowed() && !await scheduler.requestPermission()) {
      await store.save(settings.copyWith(enabled: false));
      return EnableResult.denied;
    }
    await store.save(settings.copyWith(enabled: enabled));
    await _sync();
    return EnableResult.enabled;
  });

  /// Whether notifications are allowed; false if the phone can't say.
  Future<bool> _allowed() async {
    try {
      return await scheduler.hasPermission();
    } catch (_) {
      return false;
    }
  }

  Future<void> setTime(int hour, int minute) => _serial(() async {
    final settings = await store.load();
    await store.save(settings.copyWith(hour: hour, minute: minute));
    await _sync();
  });
}
