import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../about/about_screen.dart';
import '../app/app_services.dart';
import '../app/argueless_theme.dart';
import '../reminders/reminders_section.dart';
import 'colour_choice.dart';
import 'section_header.dart';
import 'setting_stepper.dart';

/// The user's choices: the daily reminder and how the app looks. Every
/// change applies at once.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    final settings = services.settings;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ValueListenableBuilder<AppSettings>(
          valueListenable: settings,
          builder: (context, s, _) => ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const SectionHeader(title: 'Reminders'),
              RemindersSection(coordinator: services.reminders),
              const SectionHeader(title: 'Appearance'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ArguelessTheme.gutter,
                  vertical: 8,
                ),
                child: SegmentedButton<Appearance>(
                  key: const Key('appearance'),
                  segments: const [
                    ButtonSegment(
                      value: Appearance.system,
                      label: Text('Phone'),
                      icon: Icon(Icons.phone_android_rounded),
                    ),
                    ButtonSegment(
                      value: Appearance.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_rounded),
                    ),
                    ButtonSegment(
                      value: Appearance.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_rounded),
                    ),
                  ],
                  selected: {s.appearance},
                  showSelectedIcon: false,
                  onSelectionChanged: (v) =>
                      settings.update(s.copyWith(appearance: v.first)),
                ),
              ),
              ColourChoice(
                label: 'Theme colour',
                colours: AppPalette.themeColors,
                value: s.themeColor,
                onChanged: (v) => settings.update(s.copyWith(themeColor: v)),
              ),
              SettingStepper(
                label: 'Text size',
                value: s.textPercent,
                range: AppSettings.textPercentRange,
                step: 10,
                format: (v) => '$v%',
                onChanged: (v) => settings.update(s.copyWith(textPercent: v)),
              ),
              const SizedBox(height: 12),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('About ArgueLess'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AboutScreen(services: services),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
