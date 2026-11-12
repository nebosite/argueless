import 'package:argueless_core/argueless_core.dart';

/// Where the user's app settings are kept.
abstract interface class SettingsStore {
  /// The saved settings, or the defaults if there are none or they cannot
  /// be read. Never throws: it runs before the app starts.
  Future<AppSettings> load();

  Future<void> save(AppSettings settings);
}
