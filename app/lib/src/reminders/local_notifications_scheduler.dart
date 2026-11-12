import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'reminder_scheduler.dart';

/// [ReminderScheduler] on the phone's own notifications. Nothing leaves the
/// device: the time zone data is bundled, and the reminder's words are
/// fixed, so nothing the user wrote ever shows on a lock screen.
class LocalNotificationsScheduler implements ReminderScheduler {
  static const _id = 1;

  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _ready;

  /// Set up once; a failed set-up is tried again next time.
  Future<void> _init() => _ready ??= _initialise().catchError((Object e) {
    _ready = null;
    throw e;
  });

  Future<void> _initialise() async {
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (error) {
      // Unknown zone: tz.local stays UTC. The first reminder is still at
      // the right moment (see scheduleDaily); later ones may be an hour
      // out across a clock change.
      debugPrint('ArgueLess: time zone not found: ${error.runtimeType}');
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    try {
      await _init();
      if (Platform.isAndroid) {
        return await _android()?.requestNotificationsPermission() ?? false;
      }
      return await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, sound: true) ??
          false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> hasPermission() async {
    await _init();
    if (Platform.isAndroid) {
      return await _android()?.areNotificationsEnabled() ?? false;
    }
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.checkPermissions();
    return ios?.isEnabled ?? false;
  }

  @override
  Future<void> scheduleDaily(DateTime first) async {
    try {
      await _init();
      await _plugin.cancel(id: _id);
      await _plugin.zonedSchedule(
        id: _id,
        // The same moment as [first], whatever zone tz.local ended up as.
        scheduledDate: tz.TZDateTime.from(first, tz.local),
        title: ReminderScheduler.title,
        body: ReminderScheduler.body,
        matchDateTimeComponents: DateTimeComponents.time,
        // Inexact: no exact-alarm permission; a few minutes late is fine.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'practice',
            'Practice reminders',
            channelDescription: 'One gentle nudge a day to practise',
            // Only "ArgueLess" on a locked phone.
            visibility: NotificationVisibility.private,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (error) {
      debugPrint(
        'ArgueLess: scheduling the reminder failed: ${error.runtimeType}',
      );
      rethrow;
    }
  }

  @override
  Future<void> cancel() async {
    try {
      await _init();
      await _plugin.cancel(id: _id);
    } catch (_) {}
  }

  AndroidFlutterLocalNotificationsPlugin? _android() => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
}
