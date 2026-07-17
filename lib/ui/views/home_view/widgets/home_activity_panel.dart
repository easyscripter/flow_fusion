import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/app_theme_extension.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/home_view/home_view_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeActivityPanel extends StatelessWidget {
  final HomeViewViewModel viewModel;

  const HomeActivityPanel({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final FlowFusionColors colors = context.fusionColors;
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yearAgo = today.subtract(const Duration(days: 364));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeActivityTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.homeActivitySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            Observer(
              builder: (BuildContext context) => HeatMap(
                startDate: yearAgo,
                endDate: today,
                datasets: viewModel.focusByDay,
                colorMode: ColorMode.opacity,
                defaultColor: colors.panelMuted,
                textColor: colors.mutedForeground,
                showText: false,
                showColorTip: true,
                scrollable: true,
                size: 14,
                margin: const EdgeInsets.all(2.5),
                borderRadius: 4,
                colorsets: <int, Color>{1: colors.success},
                colorTipHelper: [
                  Text(
                    l10n.homeActivityLess,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                  Text(
                    l10n.homeActivityMore,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
