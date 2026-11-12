import 'dart:convert';

import 'package:argueless_core/argueless_core.dart';
import 'package:test/test.dart';

void main() {
  group('AppSettings', () {
    test('round-trips through JSON', () {
      const settings = AppSettings(
        appearance: Appearance.dark,
        themeColor: 0xFF00796B,
        textPercent: 120,
      );
      expect(AppSettings.fromJson(jsonDecode(jsonEncode(settings))), settings);
    });

    test('anything unreadable takes its default', () {
      expect(AppSettings.fromJson(null), const AppSettings());
      expect(AppSettings.fromJson('nonsense'), const AppSettings());
      expect(
        AppSettings.fromJson({
          'appearance': 'purple',
          'themeColor': 0xFF123456,
          'textPercent': 'big',
        }),
        const AppSettings(),
      );
    });

    test('text size is clamped to its range', () {
      expect(AppSettings.fromJson({'textPercent': 500}).textPercent, 150);
      expect(AppSettings.fromJson({'textPercent': 10}).textPercent, 80);
      expect(AppSettings.fromJson({'textPercent': 109.6}).textPercent, 110);
    });

    test('the default colour is the first in the palette', () {
      expect(AppSettings.defaultThemeColor, AppPalette.themeColors.first);
      for (final c in AppPalette.themeColors) {
        expect(AppPalette.names[c], isNotNull);
      }
    });
  });

  group('ReminderSettings', () {
    test('round-trips through JSON', () {
      const settings = ReminderSettings(enabled: true, hour: 7, minute: 30);
      expect(
        ReminderSettings.fromJson(jsonDecode(jsonEncode(settings))),
        settings,
      );
    });

    test('anything unreadable is off', () {
      const off = ReminderSettings.off();
      expect(ReminderSettings.fromJson(null), off);
      expect(
        ReminderSettings.fromJson({'enabled': true, 'hour': 24, 'minute': 0}),
        off,
      );
      expect(
        ReminderSettings.fromJson({'enabled': 'yes', 'hour': 7, 'minute': 0}),
        off,
      );
      expect(off.enabled, isFalse);
    });
  });

  group('ReminderPlan', () {
    DateTime first(DateTime now, {bool practised = false}) =>
        ReminderPlan.first(
          now: now,
          hour: 19,
          minute: 0,
          practisedToday: practised,
        );

    test('today when the time is still ahead', () {
      expect(first(DateTime(2026, 11, 10, 8)), DateTime(2026, 11, 10, 19));
    });

    test('tomorrow once the time has passed', () {
      expect(first(DateTime(2026, 11, 10, 19)), DateTime(2026, 11, 11, 19));
      expect(first(DateTime(2026, 11, 10, 22)), DateTime(2026, 11, 11, 19));
    });

    test('tomorrow after practising today', () {
      expect(
        first(DateTime(2026, 11, 10, 8), practised: true),
        DateTime(2026, 11, 11, 19),
      );
    });

    test('across the end of a month and a year', () {
      expect(first(DateTime(2026, 12, 31, 20)), DateTime(2027, 1, 1, 19));
    });
  });
}
