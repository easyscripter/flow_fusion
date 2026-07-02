import 'package:flow_fusion/ui/app/active_timer_controller.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/home_view/home_view_view_model.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flow_fusion/ui/widgets/home_activity_panel.dart';
import 'package:flow_fusion/ui/widgets/home_stats_row.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewViewModel _viewModel = HomeViewViewModel();
  late final ActiveTimerController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = GetIt.I.get<ActiveTimerController>();
    _timerController.addListener(_onTimerControllerChanged);
    _viewModel.init();
  }

  @override
  void dispose() {
    _timerController.removeListener(_onTimerControllerChanged);
    super.dispose();
  }

  void _onTimerControllerChanged() {
    final isActive = _timerController.hasActiveSession;
    if (!isActive && !_viewModel.isLoading) {
      _viewModel.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppPageHeader(
                title: context.l10n.homeTitle,
                subtitle: context.l10n.homeSubtitle,
              ),
              const SizedBox(height: AppSizes.paddingLarge),
              HomeStatsRow(viewModel: _viewModel),
              const SizedBox(height: AppSizes.paddingLarge),
              HomeActivityPanel(viewModel: _viewModel),
            ],
          ),
        ),
      ),
    );
  }
}
