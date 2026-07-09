import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class StatCardGrid extends StatelessWidget {
  final List<Widget> children;
  final int maxColumns;
  final double spacing;

  final List<double> breakpoints;

  const StatCardGrid({
    super.key,
    required this.children,
    this.maxColumns = 4,
    this.spacing = AppSizes.gridSpacing,
    this.breakpoints = const <double>[560, 880, 1100],
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int columns = 1;
        for (final double bp in breakpoints) {
          if (constraints.maxWidth > bp) columns++;
        }
        columns = columns.clamp(1, maxColumns);

        final double cardWidth =
            (constraints.maxWidth - (columns - 1) * spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final Widget child in children)
              SizedBox(width: cardWidth, child: child),
          ],
        );
      },
    );
  }
}
