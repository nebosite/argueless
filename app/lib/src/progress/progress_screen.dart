import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/app_services.dart';
import '../app/argueless_theme.dart';
import 'reflection_chart.dart';
import 'stat_tile.dart';

/// Progress over time: the reflection chart, the share of moments that went
/// generously, and practice totals.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.services});

  final AppServices services;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<Reflection>? _reflections;
  PracticeStats? _stats;
  bool _weekly = false;

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
    });
  }

  static String _percent(double? share) =>
      share == null ? '–' : '${(share * 100).round()}%';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reflections = _reflections;
    final stats = _stats;
    if (reflections == null || stats == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Progress')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final today = widget.services.today;
    final series = ReflectionSeries(reflections);
    final buckets = _weekly
        ? series.weekly(end: today)
        : series.daily(end: today);
    final weeks = series.weekly(end: today, count: 2);
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(ArguelessTheme.gutter),
          children: [
            Text(
              'How tricky moments went',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('2 weeks')),
                ButtonSegment(value: true, label: Text('12 weeks')),
              ],
              selected: {_weekly},
              onSelectionChanged: (s) => setState(() => _weekly = s.first),
            ),
            const SizedBox(height: 16),
            ReflectionChart(buckets: buckets, weekly: _weekly),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    value: _percent(weeks.last.generousShare),
                    label: 'went generously\nthis week',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    value: _percent(weeks.first.generousShare),
                    label: 'went generously\nlast week',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
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
          ],
        ),
      ),
    );
  }
}
