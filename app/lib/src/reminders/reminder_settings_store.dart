import 'package:argueless_core/argueless_core.dart';

/// Where the reminder setting is kept.
abstract interface class ReminderSettingsStore {
  /// The saved setting, or [ReminderSettings.off] if there is none or it
  /// is garbled. Other read errors are thrown.
  Future<ReminderSettings> load();

  /// Whether anything has ever been saved: once it has, the user has
  /// been offered reminders and is never offered them again.
  Future<bool> hasSaved();

  Future<void> save(ReminderSettings settings);
}
