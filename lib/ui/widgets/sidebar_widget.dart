import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/app_badge.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarWidget extends StatelessWidget {
  final String packageVersion;

  const SidebarWidget({super.key, required this.packageVersion});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == Routes.home.path) {
      return 0;
    } else if (location == Routes.sessions.path) {
      return 1;
    } else if (location == Routes.settings.path) {
      return 2;
    }
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Routes.home.path);
        break;
      case 1:
        context.go(Routes.sessions.path);
        break;
      case 2:
        context.go(Routes.settings.path);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Container(
      width: AppSizes.sidebarWidth,
      decoration: BoxDecoration(
        color: context.fusionColors.sidebarBackground,
        border: Border(
          right: BorderSide(color: context.fusionColors.sidebarBorder),
        ),
      ),
      child: NavigationDrawer(
        onDestinationSelected: (index) => _onDestinationSelected(context, index),
        selectedIndex: selectedIndex,
        tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        header: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingLarge,
            28,
            AppSizes.paddingLarge,
            12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flow Fusion',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              const AppBadge(
                label: 'Dark by default',
                icon: Icons.nightlight_round,
              ),
            ],
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Text(
            'v$packageVersion',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.fusionColors.mutedForeground,
            ),
          ),
        ),
        children: const [
          NavigationDrawerDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: Text('Обзор'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule_rounded),
            label: Text('Сессии'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: Text('Настройки'),
          ),
        ],
      ),
    );
  }
}
