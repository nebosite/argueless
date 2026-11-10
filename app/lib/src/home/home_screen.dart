import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../about/about_screen.dart';
import '../app/app_services.dart';
import '../app/argueless_theme.dart';
import '../practice/practice_launcher.dart';
import '../progress/progress_screen.dart';
import '../reflect/reflect_screen.dart';
import 'action_card.dart';
import 'streak_chip.dart';
import 'subject_card.dart';

/// Where every day starts: today's practice, the subjects, the daily
/// reflection, and progress.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.services});

  final AppServices services;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PracticeStats? _stats;
  Reflection? _reflection;

  AppServices get _services => widget.services;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    var records = const <PracticeRecord>[];
    Reflection? reflection;
    try {
      records = await _services.practiceLog.all();
      reflection = await _services.reflectionLog.on(_services.today);
    } catch (e) {
      // Home must always open; the numbers just show as zero.
      debugPrint('ArgueLess: home load failed: ${e.runtimeType}');
    }
    if (!mounted) return;
    setState(() {
      _stats = PracticeStats(records, today: _services.today);
      _reflection = reflection;
    });
  }

  Future<void> _practise({String? subjectId}) async {
    await PracticeLauncher(_services).start(context, subjectId: subjectId);
    await _load();
  }

  Future<void> _open(Widget screen) async {
    await Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => screen));
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _stats;
    final theme = Theme.of(context);
    final done = stats?.practisedToday ?? 0;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            ArguelessTheme.gutter,
            12,
            ArguelessTheme.gutter,
            32,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'ArgueLess',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                StreakChip(days: stats?.streak ?? 0),
                IconButton(
                  tooltip: 'About ArgueLess',
                  icon: const Icon(Icons.info_outline_rounded),
                  onPressed: () => _open(AboutScreen(services: _services)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Curious beats right. A few minutes a day.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ActionCard(
              key: const Key('today'),
              icon: Icons.play_arrow_rounded,
              title: done == 0 ? "Today's practice" : 'One more?',
              subtitle: done == 0
                  ? 'One scenario, about 5 minutes.'
                  : 'Done today: $done · ${stats!.minutesToday} min. '
                        'Aim for 5 to 15.',
              color: theme.colorScheme.primary,
              filled: true,
              onTap: _practise,
            ),
            const SizedBox(height: 12),
            ActionCard(
              key: const Key('reflect'),
              icon: Icons.wb_twilight_rounded,
              title: _reflection == null
                  ? 'Look back on the last day'
                  : 'Reflected today',
              subtitle: _reflection == null
                  ? 'Count the tricky moments and how they went.'
                  : '${_reflection!.automatic + _reflection!.recovered} '
                        'went generously. Tap to change.',
              color: ArguelessTheme.sunshine,
              onTap: () => _open(ReflectScreen(services: _services)),
            ),
            const SizedBox(height: 12),
            ActionCard(
              key: const Key('progress'),
              icon: Icons.insights_rounded,
              title: 'Progress',
              subtitle: stats == null || stats.totalPractices == 0
                  ? 'Your chart grows as you reflect.'
                  : '${stats.totalPractices} practices, '
                        '${stats.totalIdeas} ideas so far.',
              color: theme.colorScheme.tertiary,
              onTap: () => _open(ProgressScreen(services: _services)),
            ),
            const SizedBox(height: 28),
            Text(
              'Pick a subject',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            for (final subject in _services.library.subjects) ...[
              SubjectCard(
                subject: subject,
                practised: stats?.practisedIn(subject.id) ?? 0,
                total: _services.library.scenariosFor(subject.id).length,
                onTap: () => _practise(subjectId: subject.id),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
