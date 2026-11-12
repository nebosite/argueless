import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/app_services.dart';
import 'brainstorm_step.dart';
import 'finish_view.dart';
import 'leave_practice_dialog.dart';
import 'review_step.dart';
import 'save_failed_view.dart';
import 'roleplay_step.dart';
import 'scenario_header.dart';
import 'step_dots.dart';

/// One practice, step by step: brainstorm reframes, compare and rate,
/// brainstorm phrases, compare and rate, role-play, finish.
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({
    super.key,
    required this.services,
    required this.scenario,
  });

  final AppServices services;
  final Scenario scenario;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late PracticeSession _session;
  PracticeRecord? _record;
  PracticeStats? _stats;

  /// The finished practice, kept until it is safely saved.
  PracticeRecord? _pending;
  bool _pendingAdded = false;
  bool _saveFailed = false;

  /// Leaving or moving on is under way; further taps are ignored.
  bool _busy = false;

  AppServices get _services => widget.services;

  @override
  void initState() {
    super.initState();
    _begin(widget.scenario);
  }

  void _begin(Scenario scenario) {
    _session = PracticeSession(
      scenario: scenario,
      library: _services.library,
      startedAt: _services.clock.now(),
    );
    _record = null;
    _stats = null;
    _pending = null;
    _pendingAdded = false;
    _saveFailed = false;
  }

  Future<void> _advance() async {
    setState(_session.advance);
    if (_session.step == PracticeStep.done) await _save();
  }

  /// Saves the finished practice. On failure it stays in memory and the
  /// user can try again.
  Future<void> _save() async {
    final record = _pending ??= _session.record(
      finishedAt: _services.clock.now(),
    );
    if (_saveFailed) setState(() => _saveFailed = false);
    try {
      // A retry after the add worked must not add it twice.
      if (!_pendingAdded) await _services.practiceLog.add(record);
      _pendingAdded = true;
      final stats = PracticeStats(
        await _services.practiceLog.all(),
        today: _services.today,
      );
      if (!mounted) return;
      setState(() {
        _record = record;
        _stats = stats;
      });
    } catch (e) {
      debugPrint('ArgueLess: practice save failed: ${e.runtimeType}');
      if (mounted) setState(() => _saveFailed = true);
    }
  }

  void _home() {
    if (_busy) return;
    _busy = true;
    Navigator.of(context).pop();
  }

  Future<void> _another() async {
    if (_busy) return;
    _busy = true;
    Scenario? next;
    try {
      next = await _services.scenarios.next(
        subjectId: _session.scenario.subjectId,
        excluding: _session.scenario.id,
      );
    } catch (e) {
      debugPrint('ArgueLess: next scenario failed: ${e.runtimeType}');
    }
    final found = next;
    if (!mounted) return;
    if (found == null) {
      // Nothing more to offer (or it failed): back home.
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _begin(found);
      _busy = false;
    });
  }

  /// Leaving mid-practice loses the ideas, so ask once there are any.
  Future<void> _confirmLeave() async {
    final untouched =
        _session.step == PracticeStep.reframes && !_session.reframes.hasIdeas;
    if (untouched || await LeavePracticeDialog.show(context)) {
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final subject = _services.library.subject(_session.scenario.subjectId)!;
    final done = _session.step == PracticeStep.done;
    return PopScope(
      canPop: done,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(subject.title),
          bottom: done
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  child: StepDots(step: _session.step),
                ),
        ),
        body: SafeArea(child: done ? _finish(subject) : _step(subject)),
      ),
    );
  }

  Widget _finish(Subject subject) {
    final record = _record;
    final stats = _stats;
    if (_saveFailed) return SaveFailedView(onRetry: _save);
    if (record == null || stats == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return FinishView(
      scenario: _session.scenario,
      subject: subject,
      record: record,
      stats: stats,
      onAnother: _another,
      onHome: _home,
    );
  }

  Widget _step(Subject subject) {
    final header = ScenarioHeader(
      scenario: _session.scenario,
      subject: subject,
      // Once the user has moved on, the situation folds away to give the
      // step room, but can be opened again.
      collapsed: _session.step != PracticeStep.reframes,
    );
    final key = ValueKey('${_session.scenario.id}-${_session.step.name}');
    return switch (_session.step) {
      PracticeStep.reframes => BrainstormStep(
        key: key,
        header: header,
        round: _session.reframes,
        prompt: 'How else could you see this?',
        hint: 'A new way to think about it…',
        explainer:
            'List as many reframes as you can: thoughts that would invite '
            'a curious, kinder response instead of a defensive one.',
        speech: _services.speech,
        onChanged: () => setState(() {}),
        onContinue: _advance,
      ),
      PracticeStep.reframeReview => ReviewStep(
        key: key,
        header: header,
        round: _session.reframes,
        scale: _services.library.scale,
        suggestionsTitle: 'Reframes others came up with',
        heartHint:
            'Tap the heart on any that ring true and bring up a softer '
            "feeling. It's fine if none do.",
        onChanged: () => setState(() {}),
        onContinue: _advance,
      ),
      PracticeStep.phrases => BrainstormStep(
        key: key,
        header: header,
        round: _session.phrases,
        prompt: 'What could you actually say?',
        hint: 'Words you would say out loud…',
        explainer:
            'Now turn the new thinking into words: what you would say to '
            'them or to yourself. Questions, "I" statements, and playing '
            'back what you heard all count.',
        speech: _services.speech,
        onChanged: () => setState(() {}),
        onContinue: _advance,
      ),
      PracticeStep.phraseReview => ReviewStep(
        key: key,
        header: header,
        round: _session.phrases,
        scale: _services.library.scale,
        suggestionsTitle: 'Phrases to borrow',
        heartHint:
            'Tap the heart on any that ring true and bring up a softer '
            "feeling. It's fine if none do. Hearted ones join your choices "
            'for the role-play.',
        onChanged: () => setState(() {}),
        onContinue: _advance,
      ),
      PracticeStep.roleplay => RoleplayStep(
        key: key,
        session: _session,
        speech: _services.speech,
        onChanged: () => setState(() {}),
        onContinue: _advance,
      ),
      PracticeStep.done => const SizedBox.shrink(),
    };
  }
}
