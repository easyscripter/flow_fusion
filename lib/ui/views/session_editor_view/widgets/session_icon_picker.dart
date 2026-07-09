import 'package:flow_fusion/ui/constants/session_icons.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/session_icon_option.dart';
import 'package:flutter/material.dart';

class SessionIconPicker extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const SessionIconPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final name in SessionIcons.names)
          SessionIconOption(
            name: name,
            selected: name == selected,
            onTap: () => onSelected(name),
          ),
      ],
    );
  }
}
