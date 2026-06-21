import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/number_stepper_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberStepperField extends StatefulWidget {
  final int value;

  final ValueChanged<int> onChanged;

  final int min;
  final int max;

  final int step;

  final String? suffixText;

  /// Optional fill behind the field. Defaults to the theme input fill.
  final Color? fillColor;

  /// Whether to draw the rounded outline. The pill shape is kept either way.
  final bool showBorder;

  final double width;

  const NumberStepperField({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.suffixText,
    this.fillColor,
    this.showBorder = true,
    this.width = 112,
  });

  @override
  State<NumberStepperField> createState() => _NumberStepperFieldState();
}

class _NumberStepperFieldState extends State<NumberStepperField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.value}');
  }

  @override
  void didUpdateWidget(covariant NumberStepperField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final text = '${widget.value}';
    if (widget.value != oldWidget.value && _controller.text != text) {
      _controller.text = text;
      _controller.selection = TextSelection.collapsed(offset: text.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _clamp(int value) => value.clamp(widget.min, widget.max).toInt();

  void _onChangedText(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) return;
    widget.onChanged(_clamp(parsed));
  }

  void _normalize() {
    final text = '${widget.value}';
    if (_controller.text != text) _controller.text = text;
  }

  void _step(int delta) => widget.onChanged(_clamp(widget.value + delta));

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final canIncrement = widget.value < widget.max;
    final canDecrement = widget.value > widget.min;

    return SizedBox(
      width: widget.width,
      child: TextField(
        controller: _controller,
        onChanged: _onChangedText,
        onEditingComplete: _normalize,
        onTapOutside: (_) => _normalize(),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          isDense: true,
          filled: widget.fillColor != null,
          fillColor: widget.fillColor,
          suffixText: widget.suffixText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          suffixIcon: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NumberStepperButton(
                icon: Icons.keyboard_arrow_up_rounded,
                color: canIncrement
                    ? colors.mutedForeground
                    : colors.lineStrong,
                onTap: canIncrement ? () => _step(widget.step) : null,
              ),
              NumberStepperButton(
                icon: Icons.keyboard_arrow_down_rounded,
                color: canDecrement
                    ? colors.mutedForeground
                    : colors.lineStrong,
                onTap: canDecrement ? () => _step(-widget.step) : null,
              ),
            ],
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 24,
            minHeight: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: widget.showBorder
                ? BorderSide(color: colors.cardBorder)
                : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: widget.showBorder
                ? BorderSide(color: colors.cardBorder)
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: widget.showBorder
                ? BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.2,
                  )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
