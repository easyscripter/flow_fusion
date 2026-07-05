import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/widgets/update/release_notes_section_view.dart';
import 'package:flutter/material.dart';

class ReleaseNotesView extends StatelessWidget {
  const ReleaseNotesView({super.key, required this.notes});

  final ReleaseNotes notes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = notes.summary?.trim();
    final hasSummary = summary != null && summary.isNotEmpty;

    if (!hasSummary && notes.sections.isEmpty) {
      return Text(context.l10n.releaseNotesEmpty);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasSummary) ...[
          Text(summary, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
        ],
        for (final section in notes.sections) ...[
          ReleaseNotesSectionView(section: section),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
