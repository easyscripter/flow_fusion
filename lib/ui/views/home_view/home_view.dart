import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/home_view/home_view_view_model.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flow_fusion/ui/widgets/error_retry.dart';
import 'package:flow_fusion/ui/views/home_view/widgets/home_activity_panel.dart';
import 'package:flow_fusion/ui/views/home_view/widgets/home_stats_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I.get<HomeViewViewModel>();
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
              Observer(
                builder: (context) {
                  if (_viewModel.hasError) {
                    return ErrorRetry(
                      message: context.l10n.errorLoadFailed,
                      onRetry: _viewModel.update,
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeStatsRow(viewModel: _viewModel),
                      const SizedBox(height: AppSizes.paddingLarge),
                      HomeActivityPanel(viewModel: _viewModel),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
