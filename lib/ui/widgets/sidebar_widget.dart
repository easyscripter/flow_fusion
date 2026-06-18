import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/brand_logo.dart';
import 'package:flow_fusion/ui/widgets/sidebar_nav_button.dart';
import 'package:flow_fusion/ui/widgets/sidebar_section_label.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Описание одного пункта навигации сайдбара.
class _NavItem {
  final Routes route;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class SidebarWidget extends StatelessWidget {
  final String packageVersion;

  const SidebarWidget({super.key, required this.packageVersion});

  static const _items = <_NavItem>[
    _NavItem(
      route: Routes.home,
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      label: 'Обзор',
    ),
    _NavItem(
      route: Routes.sessions,
      icon: Icons.schedule_outlined,
      selectedIcon: Icons.schedule_rounded,
      label: 'Сессии',
    ),
    _NavItem(
      route: Routes.settings,
      icon: Icons.tune_outlined,
      selectedIcon: Icons.tune_rounded,
      label: 'Настройки',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final location = GoRouterState.of(context).uri.path;

    return Container(
      width: AppSizes.sidebarWidth,
      decoration: BoxDecoration(
        color: colors.sidebarBackground,
        border: Border(right: BorderSide(color: colors.sidebarBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBrand(context),
          Divider(height: 1, thickness: 1, color: colors.sidebarBorder),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingSmall,
                vertical: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SidebarSectionLabel(label: 'Приложение'),
                  for (final item in _items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: SidebarNavButton(
                        icon: item.icon,
                        selectedIcon: item.selectedIcon,
                        label: item.label,
                        selected: location == item.route.path,
                        onTap: () => context.go(item.route.path),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: colors.sidebarBorder),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Text(
              'v$packageVersion',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.mutedForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLarge,
        28,
        AppSizes.paddingLarge,
        20,
      ),
      child: Row(
        children: [
          const BrandLogo(),
          const SizedBox(width: 12),
          Expanded(
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
                Text(
                  'Focus workspace',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.fusionColors.mutedForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
