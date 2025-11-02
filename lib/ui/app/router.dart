import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/views/home_view/home_view.dart';
import 'package:flow_fusion/ui/views/sessions_view/sessions_view.dart';
import 'package:flow_fusion/ui/views/settings_view/settings_view.dart';
import 'package:flow_fusion/ui/widgets/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home.path,
              pageBuilder: (context, state) =>
                  NoTransitionPage(key: state.pageKey, child: const HomeView()),
            ),
            GoRoute(
              path: Routes.sessions.path,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const SessionsView(),
              ),
            ),
            GoRoute(
              path: Routes.settings.path,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const SettingsView(),
              ),
            ),
          ],
        ),
      ],
      builder: (context, state, navigationShell) {
        final viewModel = GetIt.I.get<AppViewModel>();

        return Observer(
          builder: (_) => Scaffold(
            body: Row(
              children: [
                SidebarWidget(packageVersion: viewModel.packageVersion),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        );
      },
    ),
  ],
);
