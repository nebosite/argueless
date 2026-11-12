import 'package:argueless/src/reminders/reminder_settings_store.dart';
import 'package:argueless_core/argueless_core.dart';

/// The reminder setting in memory; [saved] null means never saved.
class MemoryReminderSettingsStore implements ReminderSettingsStore {
  MemoryReminderSettingsStore([this.saved]);

  /// Already answered (off), so reminders are not offered: the default for
  /// tests that are not about the offer.
  MemoryReminderSettingsStore.answered() : saved = const ReminderSettings.off();

  ReminderSettings? saved;

  @override
  Future<ReminderSettings> load() async =>
      saved ?? const ReminderSettings.off();

  @override
  Future<bool> hasSaved() async => saved != null;

  @override
  Future<void> save(ReminderSettings settings) async => saved = settings;
}
