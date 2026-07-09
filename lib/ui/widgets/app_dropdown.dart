import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.fusionColors.cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          hint: hint != null ? Text(hint!) : null,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          dropdownColor: Theme.of(context).colorScheme.surface,
          focusColor: Colors.transparent,
        ),
      ),
    );
  }
}
