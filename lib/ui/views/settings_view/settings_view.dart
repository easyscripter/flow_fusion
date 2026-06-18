import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/app_badge.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flow_fusion/ui/widgets/app_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _appViewModel = GetIt.I.get<AppViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppPageHeader(
              title: context.l10n.settingsTitle,
              subtitle: context.l10n.settingsSubtitle,
              trailing: AppBadge(
                label: context.l10n.badgeTheme,
                icon: Icons.palette_outlined,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSettingsSection(
                      context,
                      title: context.l10n.settingsSectionAppearance,
                      children: [
                        Observer(builder: (_) => _buildThemeTile(context)),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingLarge),
                    _buildSettingsSection(
                      context,
                      title: context.l10n.settingsSectionLanguage,
                      children: [
                        Observer(builder: (_) => _buildLanguageTile(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        AppPanel(child: Column(children: children)),
      ],
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getThemeIcon(),
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.settingsTheme,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Text(
            context.l10n.settingsThemeDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.fusionColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppBadge(label: context.l10n.badgeNeutralSurfaces),
              AppBadge(label: context.l10n.badgeSubtleBorders),
              AppBadge(label: context.l10n.badgeRoundedCorners),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                icon: const Icon(Icons.brightness_auto_outlined),
                label: Text(context.l10n.themeSystem),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode_outlined),
                label: Text(context.l10n.themeDark),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode_outlined),
                label: Text(context.l10n.themeLight),
              ),
            ],
            selected: {_appViewModel.themeMode},
            onSelectionChanged: (selection) {
              _appViewModel.setThemeMode(selection.first);
            },
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon() => switch (_appViewModel.themeMode) {
    ThemeMode.light => Icons.light_mode,
    ThemeMode.dark => Icons.dark_mode,
    ThemeMode.system => Icons.brightness_auto_outlined,
  };

  Widget _buildLanguageTile(BuildContext context) {
    // `null` — следовать языку системы; иначе код локали.
    final currentCode = _appViewModel.locale?.languageCode;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.translate_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                context.l10n.settingsSectionLanguage,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          SegmentedButton<String?>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment<String?>(
                value: null,
                icon: const Icon(Icons.brightness_auto_outlined),
                label: Text(context.l10n.languageSystem),
              ),
              ButtonSegment<String?>(
                value: 'en',
                label: Text(context.l10n.languageEnglish),
              ),
              ButtonSegment<String?>(
                value: 'ru',
                label: Text(context.l10n.languageRussian),
              ),
            ],
            selected: {currentCode},
            onSelectionChanged: (selection) {
              final code = selection.first;
              _appViewModel.setLocale(code == null ? null : Locale(code));
            },
          ),
        ],
      ),
    );
  }
}
