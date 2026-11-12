import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/app_services.dart';
import '../app/argueless_theme.dart';
import 'journal_entry_card.dart';
import 'ratings_section.dart';
import 'stat_tile.dart';

/// Progress over time: practice totals, self-ratings by rubric criterion,
/// and the journal, newest first.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.services});

  final AppServices services;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<Reflection>? _reflections;
  PracticeStats? _stats;
  RatingStats? _ratings;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    var reflections = const <Reflection>[];
    var records = const <PracticeRecord>[];
    try {
      reflections = await widget.services.reflectionLog.all();
      records = await widget.services.practiceLog.all();
    } catch (e) {
      debugPrint('ArgueLess: progress load failed: ${e.runtimeType}');
    }
    if (!mounted) return;
    setState(() {
      _reflections = reflections;
      _stats = PracticeStats(records, today: widget.services.today);
      _ratings = RatingStats(
        records,
        library: widget.services.library,
        today: widget.services.today,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reflections = _reflections;
    final stats = _stats;
    final ratings = _ratings;
    if (reflections == null || stats == null || ratings == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Progress')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final journal = [
      for (final r in reflections.reversed)
        if (r.note.trim().isNotEmpty || r.hasOnlyCounts) r,
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(ArguelessTheme.gutter),
          children: [
            Text(
              'Practice',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    value: '${stats.streak}',
                    label: 'day streak',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    value: '${stats.totalPractices}',
                    label: 'practices',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    value: '${stats.totalIdeas}',
                    label: 'ideas written',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final subject in widget.services.library.subjects)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(subject.title),
                trailing: Text(
                  '${stats.practisedIn(subject.id)}',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            const SizedBox(height: 28),
            RatingsSection(
              stats: ratings,
              scale: widget.services.library.scale,
            ),
            const SizedBox(height: 28),
            Text(
              'Your journal',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            if (journal.isEmpty)
              Text(
                'What you write in the journal will show here.',
                style: theme.textTheme.bodyMedium,
              ),
            for (final entry in journal) JournalEntryCard(entry: entry),
          ],
        ),
      ),
    );
  }
}
