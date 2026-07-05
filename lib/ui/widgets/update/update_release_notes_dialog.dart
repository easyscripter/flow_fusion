import 'package:desktop_updater/desktop_updater.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/widgets/update/release_notes_view.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/material.dart';

class UpdateReleaseNotesDialog extends StatefulWidget {
  const UpdateReleaseNotesDialog({
    super.key,
    required this.controller,
    required this.version,
  });

  final DesktopUpdaterController controller;
  final String version;

  @override
  State<UpdateReleaseNotesDialog> createState() =>
      _UpdateReleaseNotesDialogState();
}

class _UpdateReleaseNotesDialogState extends State<UpdateReleaseNotesDialog> {
  ReleaseNotes? _notes;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final notes = await widget.controller.loadReleaseNotes();
      if (!mounted) return;
      setState(() {
        _notes = notes;
        _loading = false;
      });
    } catch (e, s) {
      AppLogger.error('UpdateReleaseNotesDialog.load', e, s);
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notes = _notes;
    return AlertDialog(
      title: Text(context.l10n.updateWhatsNewTitle(widget.version)),
      content: SizedBox(
        width: 420,
        child: switch ((_loading, _failed, notes)) {
          (true, _, _) => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          (_, true, _) => Text(context.l10n.releaseNotesFailed),
          (_, _, final loaded?) => SingleChildScrollView(
            child: ReleaseNotesView(notes: loaded),
          ),
          _ => Text(context.l10n.releaseNotesEmpty),
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.updateActionClose),
        ),
      ],
    );
  }
}
