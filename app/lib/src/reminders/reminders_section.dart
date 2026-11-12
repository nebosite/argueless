import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/argueless_theme.dart';
import '../settings/setting_switch.dart';
import 'reminder_coordinator.dart';

/// Turn the daily practice reminder on or off and choose its time. Part of
/// the Settings page.
class RemindersSection extends StatefulWidget {
  const RemindersSection({super.key, required this.coordinator});

  final ReminderCoordinator coordinator;

  @override
  State<RemindersSection> createState() => _RemindersSectionState();
}

class _RemindersSectionState extends State<RemindersSection> {
  ReminderSettings? _settings;

  /// The last turning on was refused notification permission.
  bool _denied = false;

  /// The last change could not be carried out.
  bool _failed = false;
  bool _busy = false;

  /// Back from the phone's settings: show what is now true.
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onResume: () async {
      try {
        await widget.coordinator.sync();
      } catch (_) {
        // The switch shows what is stored.
      }
      if (mounted) await _load();
    },
  );

  @override
  void initState() {
    super.initState();
    _lifecycle; // created now, so it listens from the start
    _load();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    ReminderSettings settings;
    try {
      settings = await widget.coordinator.settings();
    } catch (_) {
      // Unreadable just now: show the last known state, or off.
      settings = _settings ?? const ReminderSettings.off();
    }
    if (mounted) setState(() => _settings = settings);
  }

  Future<void> _setEnabled(bool enabled) async {
    setState(() => _busy = true);
    var denied = false;
    var failed = false;
    try {
      denied =
          await widget.coordinator.setEnabled(enabled) == EnableResult.denied;
    } catch (_) {
      failed = true;
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _denied = denied;
          _failed = failed;
        });
      }
    }
    await _load();
  }

  Future<void> _pickTime() async {
    final settings = _settings!;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
      helpText: 'Remind me at',
    );
    if (time == null || !mounted) return;
    var failed = false;
    try {
      await widget.coordinator.setTime(time.hour, time.minute);
    } catch (_) {
      failed = true;
    }
    if (mounted) setState(() => _failed = failed);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;
    if (settings == null) {
      return const LinearProgressIndicator(
        minHeight: 3,
        semanticsLabel: 'Loading',
      );
    }
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay(hour: settings.hour, minute: settings.minute));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingSwitch(
          key: const Key('reminder-switch'),
          title: const Text('Daily practice reminder'),
          subtitle: const Text(
            'One gentle nudge a day, skipped on days you have practised.',
          ),
          value: settings.enabled,
          onChanged: _busy ? null : _setEnabled,
        ),
        if (settings.enabled)
          ListTile(
            key: const Key('reminder-time'),
            leading: const Icon(Icons.schedule_rounded),
            title: Text('Around $time'),
            subtitle: const Text('Tap to change'),
            onTap: _pickTime,
          ),
        if (_failed)
          Padding(
            padding: const EdgeInsets.all(ArguelessTheme.gutter),
            child: Text(
              "The reminder couldn't be set just now. Please try again.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (_denied)
          Padding(
            padding: const EdgeInsets.all(ArguelessTheme.gutter),
            child: Text(
              'Notifications are turned off for ArgueLess. To get '
              'reminders, allow notifications for it in your phone\'s '
              'settings.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
