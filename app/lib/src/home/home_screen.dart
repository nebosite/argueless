import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/app_services.dart';
import '../app/argueless_theme.dart';
import '../practice/practice_launcher.dart';
import '../progress/progress_screen.dart';
import '../reflect/reflect_screen.dart';
import '../reminders/reminder_coordinator.dart';
import '../reminders/reminder_offer_dialog.dart';
import '../settings/settings_screen.dart';
import 'action_card.dart';
import 'idea_chip.dart';
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
    // A practice today moves the next reminder to tomorrow.
    _services.reminders.sync().catchError((Object e) {
      debugPrint('ArgueLess: reminder sync failed: ${e.runtimeType}');
    });
    if (!mounted) return;
    setState(() {
      _stats = PracticeStats(records, today: _services.today);
      _reflection = reflection;
    });
  }

  Future<void> _practise({String? subjectId}) async {
    final before = _stats?.totalPractices ?? 0;
    await PracticeLauncher(_services).start(context, subjectId: subjectId);
    await _load();
    if ((_stats?.totalPractices ?? 0) > before) await _offerReminders();
  }

  /// The offer is on screen; another is never stacked on it.
  bool _offering = false;

  /// After a finished practice, reminders are offered until answered.
  Future<void> _offerReminders() async {
    final reminders = _services.reminders;
    if (_offering) return;
    _offering = true;
    try {
      if (!await reminders.shouldOffer() || !mounted) return;
      final answer = await ReminderOfferDialog.show(context);
      if (answer == null) return;
      if (!answer) {
        await reminders.decline();
        return;
      }
      final result = await reminders.setEnabled(true);
      if (result == EnableResult.denied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Notifications are off for ArgueLess. You can allow them in '
              "your phone's settings.",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('ArgueLess: reminder offer failed: ${e.runtimeType}');
    } finally {
      _offering = false;
    }
  }

  Future<void> _open(Widget screen) async {
    await Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => screen));
    await _load();
  }

  bool get _wroteToday => _reflection?.note.trim().isNotEmpty ?? false;

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
                IdeaChip(ideas: stats?.totalIdeas ?? 0),
                const SizedBox(width: 6),
                StreakChip(days: stats?.streak ?? 0),
                IconButton(
                  tooltip: 'Settings',
                  icon: const Icon(Icons.settings_rounded),
                  onPressed: () => _open(SettingsScreen(services: _services)),
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
                  : 'Done today: $done · ${stats!.minutesToday} min · '
                        '${stats.ideasToday} ideas. Aim for 5 to 15 min.',
              color: theme.colorScheme.primary,
              filled: true,
              onTap: _practise,
            ),
            const SizedBox(height: 12),
            ActionCard(
              key: const Key('reflect'),
              icon: Icons.edit_note_rounded,
              title: _wroteToday ? 'Journal written today' : 'Journal',
              subtitle: _wroteToday
                  ? 'Tap to read it or add more.'
                  : 'What did you notice over the last day?',
              color: ArguelessTheme.sunshine,
              onTap: () => _open(ReflectScreen(services: _services)),
            ),
            const SizedBox(height: 12),
            ActionCard(
              key: const Key('progress'),
              icon: Icons.insights_rounded,
              title: 'Progress',
              subtitle: stats == null || stats.totalPractices == 0
                  ? 'Your ideas and journal gather here.'
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
