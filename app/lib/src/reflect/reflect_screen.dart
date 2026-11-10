import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/app_services.dart';
import '../app/argueless_theme.dart';
import 'moment_counter.dart';

/// The daily look back over the last 24 hours: how many tricky moments
/// went each way. One reflection per day; opening it again edits it.
class ReflectScreen extends StatefulWidget {
  const ReflectScreen({super.key, required this.services});

  final AppServices services;

  @override
  State<ReflectScreen> createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  late final LocalDay _day = widget.services.today;
  Reflection? _reflection;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    Reflection? saved;
    try {
      saved = await widget.services.reflectionLog.on(_day);
    } catch (e) {
      // Start from zero; saving replaces only today's entry.
      debugPrint('ArgueLess: reflection load failed: ${e.runtimeType}');
    }
    if (!mounted) return;
    setState(() => _reflection = saved ?? Reflection(day: _day));
  }

  void _step(Reflection Function(Reflection current) change) {
    setState(() {
      final next = change(_reflection!);
      final counts = [next.automatic, next.recovered, next.conflict];
      final inRange = counts.every((c) => c >= 0 && c <= MomentCounter.max);
      if (inRange) _reflection = next;
    });
  }

  bool _saving = false;

  Future<void> _save() async {
    if (_saving) return;
    _saving = true;
    try {
      await widget.services.reflectionLog.save(_reflection!);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      debugPrint('ArgueLess: reflection save failed: ${e.runtimeType}');
      _saving = false;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Couldn't save. Check the phone has space and try again.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = _reflection;
    return Scaffold(
      appBar: AppBar(title: const Text('Look back')),
      body: r == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(ArguelessTheme.gutter),
                children: [
                  Text(
                    'Think back over the last 24 hours. How many tricky '
                    'moments did you have, and how did each one go?',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  MomentCounter(
                    key: const Key('automatic'),
                    icon: Icons.wb_sunny_rounded,
                    color: const Color(0xFF1BAF7A),
                    title: 'Generous right away',
                    subtitle: 'Curiosity came first, without trying.',
                    value: r.automatic,
                    onStep: (d) =>
                        _step((r) => r.copyWith(automatic: r.automatic + d)),
                  ),
                  const SizedBox(height: 12),
                  MomentCounter(
                    key: const Key('recovered'),
                    icon: Icons.u_turn_left_rounded,
                    color: const Color(0xFF2A78D6),
                    title: 'Caught it and turned it around',
                    subtitle:
                        'Started defensive, switched to generous before you '
                        'replied.',
                    value: r.recovered,
                    onStep: (d) =>
                        _step((r) => r.copyWith(recovered: r.recovered + d)),
                  ),
                  const SizedBox(height: 12),
                  MomentCounter(
                    key: const Key('conflict'),
                    icon: Icons.bolt_rounded,
                    color: const Color(0xFFEB6834),
                    title: 'Turned into conflict',
                    subtitle: 'It happens. Noticing it is the practice.',
                    value: r.conflict,
                    onStep: (d) =>
                        _step((r) => r.copyWith(conflict: r.conflict + d)),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('save-reflection'),
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
