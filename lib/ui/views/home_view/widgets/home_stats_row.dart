import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/utils/duration_formatter.dart';
import 'package:flow_fusion/ui/views/home_view/home_view_view_model.dart';
import 'package:flow_fusion/ui/views/home_view/widgets/stat_card.dart';
import 'package:flow_fusion/ui/views/home_view/widgets/stat_card_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeStatsRow extends StatelessWidget {
  final HomeViewViewModel viewModel;

  const HomeStatsRow({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Observer(
      builder: (BuildContext context) => StatCardGrid(
        breakpoints: const [420, 620, 760],
        children: [
          StatCard(
            icon: Icons.timer_rounded,
            value: '${viewModel.totalSessions}',
            label: l10n.homeStatTotalSessions,
            caption: l10n.homeStatTotalSessionsCaption,
          ),
          StatCard(
            icon: Icons.hourglass_bottom_rounded,
            value: formatFocusDuration(viewModel.totalFocus),
            label: l10n.homeStatTotalFocus,
            caption: l10n.homeStatTotalFocusCaption,
          ),
          StatCard(
            icon: Icons.today_rounded,
            value: formatFocusDuration(viewModel.todayFocus),
            label: l10n.homeStatTodayFocus,
            caption: l10n.homeStatTodayFocusCaption,
          ),
          StatCard(
            icon: Icons.bar_chart_rounded,
            value: formatFocusDuration(viewModel.avgSession),
            label: l10n.homeStatAvgSession,
            caption: l10n.homeStatAvgSessionCaption,
          ),
        ],
      ),
    );
  }
}
