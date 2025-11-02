import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
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

    return NavigationDrawer(
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      selectedIndex: selectedIndex,
      tilePadding: const EdgeInsets.all(2),
      indicatorShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      header: Container(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Text(
          'Flow Fusion',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      footer: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              packageVersion,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      children: [
        NavigationDrawerDestination(
          icon: const Icon(Icons.home_outlined),
          label: const Text('Главная'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.schedule_outlined),
          label: const Text('Сессии'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings_outlined),
          label: const Text('Настройки'),
        ),
      ],
    );
  }
}
