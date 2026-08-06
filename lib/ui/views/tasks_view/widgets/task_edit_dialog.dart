import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flutter/material.dart';

class TaskEditDialog extends StatefulWidget {
  const TaskEditDialog({super.key, this.initialName});

  final String? initialName;

  @override
  State<TaskEditDialog> createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  late final TextEditingController _controller;

  bool get _editing => widget.initialName != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _editing
            ? context.l10n.taskEditDialogEditTitle
            : context.l10n.taskEditDialogCreateTitle,
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: context.l10n.taskEditDialogNameHint),
        onSubmitted: (_) => _submit(context),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.taskEditDialogCancel),
        ),
        TextButton(
          onPressed: () => _submit(context),
          child: Text(context.l10n.taskEditDialogSave),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }
}
