import 'dart:io';

import 'package:argueless/src/reminders/file_reminder_settings_store.dart';
import 'package:argueless/src/settings/file_settings_store.dart';
import 'package:argueless_core/argueless_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('argueless_settings'));
  tearDown(() => dir.deleteSync(recursive: true));

  File file(String name) => File('${dir.path}${Platform.pathSeparator}$name');

  group('FileSettingsStore', () {
    test('saves and loads', () async {
      final store = FileSettingsStore(file('settings.json'));
      expect(await store.load(), const AppSettings());
      const chosen = AppSettings(
        appearance: Appearance.light,
        themeColor: 0xFF2E7D32,
        textPercent: 130,
      );
      await store.save(chosen);
      expect(await FileSettingsStore(file('settings.json')).load(), chosen);
    });

    for (final damaged in ['', 'not json', '[]', '{"textPercent": "big"}']) {
      test(
        'damaged ($damaged) gives the defaults, and saving mends it',
        () async {
          final f = file('settings.json')..writeAsStringSync(damaged);
          final store = FileSettingsStore(f);
          expect(await store.load(), const AppSettings());
          await store.save(const AppSettings(textPercent: 90));
          expect((await store.load()).textPercent, 90);
        },
      );
    }
  });

  group('FileReminderSettingsStore', () {
    test('nothing saved: off, and not yet answered', () async {
      final store = FileReminderSettingsStore(file('reminders.json'));
      expect(await store.load(), const ReminderSettings.off());
      expect(await store.hasSaved(), isFalse);
    });

    test('saves and loads', () async {
      final store = FileReminderSettingsStore(file('reminders.json'));
      const on = ReminderSettings(enabled: true, hour: 8, minute: 15);
      await store.save(on);
      expect(await store.hasSaved(), isTrue);
      expect(
        await FileReminderSettingsStore(file('reminders.json')).load(),
        on,
      );
    });

    for (final damaged in [
      '',
      'not json',
      '[]',
      '{"enabled": true, "hour": 25, "minute": 0}',
    ]) {
      test('damaged ($damaged) is off, never on', () async {
        final f = file('reminders.json')..writeAsStringSync(damaged);
        expect(
          await FileReminderSettingsStore(f).load(),
          const ReminderSettings.off(),
        );
      });
    }
  });
}
