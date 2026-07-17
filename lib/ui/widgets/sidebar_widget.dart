import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/controllers/active_timer_controller.dart';
import 'package:flow_fusion/controllers/onboarding_controller.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/onboarding/widgets/onboarding_tooltip.dart';
import 'package:flow_fusion/ui/widgets/sidebar_brand.dart';
import 'package:flow_fusion/ui/widgets/sidebar_nav_button.dart';
import 'package:flow_fusion/ui/widgets/sidebar_section_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:showcaseview/showcaseview.dart';

class _NavItem {
  final Routes route;
  final IconData icon;
  final IconData selectedIcon;
  final String Function(BuildContext context) label;
  final int showcaseStep;
  final String Function(BuildContext context) showcaseTitle;
  final String Function(BuildContext context) showcaseDescription;
  final GlobalKey Function(OnboardingController controller) showcaseKey;

  const _NavItem({
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.showcaseStep,
    required this.showcaseTitle,
    required this.showcaseDescription,
    required this.showcaseKey,
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
      showcaseStep: 2,
      showcaseTitle: _overviewShowcaseTitle,
      showcaseDescription: _overviewShowcaseDescription,
      showcaseKey: _overviewShowcaseKey,
    ),
    _NavItem(
      route: Routes.sessions,
      icon: Icons.schedule_outlined,
      selectedIcon: Icons.schedule_rounded,
      label: _sessionsLabel,
      showcaseStep: 3,
      showcaseTitle: _sessionsShowcaseTitle,
      showcaseDescription: _sessionsShowcaseDescription,
      showcaseKey: _sessionsShowcaseKey,
    ),
    _NavItem(
      route: Routes.settings,
      icon: Icons.tune_outlined,
      selectedIcon: Icons.tune_rounded,
      label: _settingsLabel,
      showcaseStep: 4,
      showcaseTitle: _settingsShowcaseTitle,
      showcaseDescription: _settingsShowcaseDescription,
      showcaseKey: _settingsShowcaseKey,
    ),
  ];

  static String _overviewLabel(BuildContext context) =>
      context.l10n.navOverview;
  static String _sessionsLabel(BuildContext context) =>
      context.l10n.navSessions;
  static String _settingsLabel(BuildContext context) =>
      context.l10n.navSettings;

  static String _overviewShowcaseTitle(BuildContext context) =>
      context.l10n.onboardingNavOverviewTitle;
  static String _overviewShowcaseDescription(BuildContext context) =>
      context.l10n.onboardingNavOverviewDescription;
  static GlobalKey _overviewShowcaseKey(OnboardingController controller) =>
      controller.navOverviewKey;

  static String _sessionsShowcaseTitle(BuildContext context) =>
      context.l10n.onboardingNavSessionsTitle;
  static String _sessionsShowcaseDescription(BuildContext context) =>
      context.l10n.onboardingNavSessionsDescription;
  static GlobalKey _sessionsShowcaseKey(OnboardingController controller) =>
      controller.navSessionsKey;

  static String _settingsShowcaseTitle(BuildContext context) =>
      context.l10n.onboardingNavSettingsTitle;
  static String _settingsShowcaseDescription(BuildContext context) =>
      context.l10n.onboardingNavSettingsDescription;
  static GlobalKey _settingsShowcaseKey(OnboardingController controller) =>
      controller.navSettingsKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final location = GoRouterState.of(context).uri.path;
    final OnboardingController onboarding =
        GetIt.I.get<OnboardingController>();

    return Container(
      width: AppSizes.sidebarWidth,
      decoration: BoxDecoration(
        color: colors.sidebarBackground,
        border: Border(right: BorderSide(color: colors.sidebarBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Showcase.withWidget(
            key: onboarding.brandKey,
            container: OnboardingTooltip(
              title: context.l10n.onboardingBrandTitle,
              description: context.l10n.onboardingBrandDescription,
              currentStep: 1,
              totalSteps: kOnboardingTotalSteps,
            ),
            child: const SidebarBrand(),
          ),
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
                      child: Showcase.withWidget(
                        key: item.showcaseKey(onboarding),
                        container: OnboardingTooltip(
                          title: item.showcaseTitle(context),
                          description: item.showcaseDescription(context),
                          currentStep: item.showcaseStep,
                          totalSteps: kOnboardingTotalSteps,
                        ),
                        child: SidebarNavButton(
                          icon: item.icon,
                          selectedIcon: item.selectedIcon,
                          label: item.label(context),
                          selected: location == item.route.path,
                          onTap: () => context.go(item.route.path),
                        ),
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
