import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/controllers/active_timer_controller.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/sidebar_brand.dart';
import 'package:flow_fusion/ui/widgets/sidebar_nav_button.dart';
import 'package:flow_fusion/ui/widgets/sidebar_section_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class _NavItem {
  final Routes route;
  final IconData icon;
  final IconData selectedIcon;
  final String Function(BuildContext context) label;

  const _NavItem({
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class SidebarWidget extends StatelessWidget {
  final String packageVersion;
  final ActiveTimerController timerController;

  const SidebarWidget({
    super.key,
    required this.packageVersion,
    required this.timerController,
  });

  static const _items = <_NavItem>[
    _NavItem(
      route: Routes.home,
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      label: _overviewLabel,
    ),
    _NavItem(
      route: Routes.sessions,
      icon: Icons.schedule_outlined,
      selectedIcon: Icons.schedule_rounded,
      label: _sessionsLabel,
    ),
    _NavItem(
      route: Routes.settings,
      icon: Icons.tune_outlined,
      selectedIcon: Icons.tune_rounded,
      label: _settingsLabel,
    ),
  ];

  static String _overviewLabel(BuildContext context) =>
      context.l10n.navOverview;
  static String _sessionsLabel(BuildContext context) =>
      context.l10n.navSessions;
  static String _settingsLabel(BuildContext context) =>
      context.l10n.navSettings;

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
          const SidebarBrand(),
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
                        label: item.label(context),
                        selected: location == item.route.path,
                        onTap: () => context.go(item.route.path),
                      ),
                    ),
                  Observer(
                    builder: (context) {
                      if (!timerController.hasActiveSession) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSizes.paddingMedium),
                          SidebarSectionLabel(
                            label: context.l10n.sidebarSectionActive,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: SidebarNavButton(
                              icon: Icons.timer_outlined,
                              selectedIcon: Icons.timer_rounded,
                              label:
                                  '${context.l10n.navTimer} (${timerController.formattedRemaining})',
                              selected: location == Routes.timer.path,
                              onTap: () => context.go(Routes.timer.path),
                            ),
                          ),
                        ],
                      );
                    },
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
}
