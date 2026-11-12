import 'package:argueless_core/argueless_core.dart';
import 'package:flutter/material.dart';

import 'day_names.dart';

/// One day's journal entry, for reading back.
class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({super.key, required this.entry});

  final Reflection entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = entry;
    final text = e.hasOnlyCounts
        // From before the journal: the counts were all there was.
        ? 'Tricky moments: ${e.automatic} generous right away, '
              '${e.recovered} turned around, ${e.conflict} into conflict.'
        : e.note;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DayNames.long(e.day),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(text, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
