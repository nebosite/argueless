import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import '../app/app_services.dart';
import '../app/argueless_theme.dart';
import '../speech/dictation_button.dart';

/// The daily journal: a few free-form lines about what the user noticed
/// over the last day, typed or spoken. One entry per day; opening it again
/// edits it. The keyboard stays closed until the user taps the page.
class ReflectScreen extends StatefulWidget {
  const ReflectScreen({super.key, required this.services});

  final AppServices services;

  @override
  State<ReflectScreen> createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  late final LocalDay _day = widget.services.today;
  final _note = TextEditingController();
  Reflection? _reflection;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    Reflection? saved;
    try {
      saved = await widget.services.reflectionLog.on(_day);
    } catch (e) {
      // Start empty; saving replaces only today's entry.
      debugPrint('ArgueLess: journal load failed: ${e.runtimeType}');
    }
    if (!mounted) return;
    setState(() {
      _reflection = saved ?? Reflection(day: _day);
      _note.text = _reflection!.note;
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    _saving = true;
    try {
      await widget.services.reflectionLog.save(
        _reflection!.copyWith(note: _note.text.trim()),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      debugPrint('ArgueLess: journal save failed: ${e.runtimeType}');
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
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: _reflection == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(ArguelessTheme.gutter),
                children: [
                  Text(
                    'What did you notice over the last day?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A tricky moment, how it went, what you felt, or '
                    'anything at all. Type, or tap the microphone and talk.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('journal-field'),
                    controller: _note,
                    minLines: 6,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Yesterday I noticed…',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      DictationButton(
                        speech: widget.services.speech,
                        controller: _note,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          key: const Key('save-reflection'),
                          onPressed: _note.text.trim().isEmpty ? null : _save,
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
