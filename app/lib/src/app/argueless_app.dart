import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import 'app_services.dart';
import 'argueless_theme.dart';

class ArguelessApp extends StatelessWidget {
  const ArguelessApp({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<AppSettings>(
    valueListenable: services.settings,
    builder: (context, settings, _) {
      final colour = Color(settings.themeColor);
      return MaterialApp(
        title: 'ArgueLess',
        debugShowCheckedModeBanner: false,
        theme: ArguelessTheme.light(colour),
        darkTheme: ArguelessTheme.dark(colour),
        themeMode: switch (settings.appearance) {
          Appearance.system => ThemeMode.system,
          Appearance.light => ThemeMode.light,
          Appearance.dark => ThemeMode.dark,
        },
        builder: (context, child) => _scaled(
          context,
          settings.textPercent,
          // Tapping anywhere that is not a button or field closes the
          // keyboard.
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child,
          ),
        ),
        home: HomeScreen(services: services),
      );
    },
  );

  /// The user's text size on top of the phone's own. At 100% the phone's
  /// scaling is left exactly as it is.
  static Widget _scaled(BuildContext context, int percent, Widget child) {
    if (percent == 100) return child;
    final media = MediaQuery.of(context);
    const base = 16.0;
    final phone = media.textScaler.scale(base) / base;
    return MediaQuery(
      data: media.copyWith(
        textScaler: TextScaler.linear(phone * percent / 100),
      ),
      child: child,
    );
  }
}
