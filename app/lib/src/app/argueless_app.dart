import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import 'app_services.dart';
import 'argueless_theme.dart';

class ArguelessApp extends StatelessWidget {
  const ArguelessApp({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'ArgueLess',
    debugShowCheckedModeBanner: false,
    theme: ArguelessTheme.light(),
    darkTheme: ArguelessTheme.dark(),
    // Tapping anywhere that is not a button or field closes the keyboard.
    builder: (context, child) => GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    ),
    home: HomeScreen(services: services),
  );
}
