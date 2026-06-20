import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/brand_logo.dart';
import 'package:flow_fusion/ui/widgets/sidebar_nav_button.dart';
import 'package:flow_fusion/ui/widgets/sidebar_section_label.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Хранит только маршрут и иконки — подпись локализуется в `build`
/// через `context.l10n`, поэтому текста в списке нет.
class _NavItem {
  final Routes route;
  final IconData icon;
  final IconData selectedIcon;

  const _NavItem({
    required this.route,
    required this.icon,
    required this.selectedIcon,
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
    ),
    _NavItem(
      route: Routes.sessions,
      icon: Icons.schedule_outlined,
      selectedIcon: Icons.schedule_rounded,
    ),
    _NavItem(
      route: Routes.settings,
      icon: Icons.tune_outlined,
      selectedIcon: Icons.tune_rounded,
    ),
  ];

  /// Локализованная подпись пункта по его маршруту.
  String _labelFor(BuildContext context, Routes route) => switch (route) {
    Routes.home => context.l10n.navOverview,
    Routes.sessions  => context.l10n.navSessions,
    Routes.settings => context.l10n.navSettings,
  };

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
                  SidebarSectionLabel(label: context.l10n.sidebarSectionApp),
                  for (final item in _items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: SidebarNavButton(
                        icon: item.icon,
                        selectedIcon: item.selectedIcon,
                        label: _labelFor(context, item.route),
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
              context.l10n.versionLabel(packageVersion),
              textAlign: TextAlign.center,
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
                  context.l10n.brandSubtitle,
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
