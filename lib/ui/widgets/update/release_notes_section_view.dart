import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flutter/material.dart';

String releaseNotesSectionLabel(
  BuildContext context,
  ReleaseNotesSectionType type,
) {
  return switch (type) {
    ReleaseNotesSectionType.features => context.l10n.releaseNotesFeatures,
    ReleaseNotesSectionType.fixes => context.l10n.releaseNotesFixes,
    ReleaseNotesSectionType.security => context.l10n.releaseNotesSecurity,
    ReleaseNotesSectionType.breaking => context.l10n.releaseNotesBreaking,
    ReleaseNotesSectionType.other => context.l10n.releaseNotesOther,
  };
}

class ReleaseNotesSectionView extends StatelessWidget {
  const ReleaseNotesSectionView({super.key, required this.section});

  final ReleaseNotesSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customTitle = section.title?.trim();
    final header = (customTitle != null && customTitle.isNotEmpty)
        ? customTitle
        : releaseNotesSectionLabel(context, section.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        for (final item in section.items)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  '),
                Expanded(child: Text(_itemText(item))),
              ],
            ),
          ),
      ],
    );
  }

  String _itemText(ReleaseNotesItem item) {
    final title = item.title?.trim();
    if (title != null && title.isNotEmpty) {
      return '$title: ${item.body}';
    }
    return item.body;
  }
}
