import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/views/settings_view/widgets/logs_setting_tile.dart';
import 'package:flow_fusion/ui/views/settings_view/widgets/manual_phase_switch_setting_tile.dart';
import 'package:flow_fusion/ui/views/settings_view/widgets/notifications_setting_tile.dart';
import 'package:flow_fusion/ui/views/settings_view/widgets/onboarding_replay_setting_tile.dart';
import 'package:flow_fusion/ui/views/settings_view/widgets/update_setting_tile.dart';
import 'package:flow_fusion/ui/widgets/app_dropdown.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flow_fusion/ui/widgets/app_panel.dart';

import 'package:flow_fusion/ui/views/settings_view/widgets/setting_row.dart';
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
                        const Divider(),
                        Observer(builder: (_) => _buildLanguageTile(context)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsSection(
                      context,
                      title: context.l10n.settingsSectionTimer,
                      children: [
                        ManualPhaseSwitchSettingTile(
                          appViewModel: _appViewModel,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsSection(
                      context,
                      title: context.l10n.settingsSectionNotifications,
                      children: [
                        NotificationsSettingTile(appViewModel: _appViewModel),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsSection(
                      context,
                      title: context.l10n.settingsSectionUpdates,
                      children: const [UpdateSettingTile()],
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsSection(
                      context,
                      title: context.l10n.settingsSectionDiagnostics,
                      children: const [LogsSettingTile()],
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsSection(
                      context,
                      title: context.l10n.settingsSectionHelp,
                      children: const [OnboardingReplaySettingTile()],
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
    return SettingRow(
      title: context.l10n.settingsTheme,
      description: context.l10n.settingsThemeDescription,
      control: AppDropdown<ThemeMode>(
        value: _appViewModel.themeMode,
        onChanged: (themeMode) {
          if (themeMode != null) {
            _appViewModel.setThemeMode(themeMode);
          }
        },
        items: [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text(context.l10n.themeSystem),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text(context.l10n.themeDark),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text(context.l10n.themeLight),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return SettingRow(
      title: context.l10n.settingsSectionLanguage,
      description: context.l10n.settingsLanguageDescription,
      control: AppDropdown<String>(
        value: _appViewModel.locale?.languageCode ?? 'en',
        onChanged: (code) {
          if (code != null) {
            _appViewModel.setLocale(Locale(code));
          }
        },
        items: [
          DropdownMenuItem(
            value: 'en',
            child: Text(context.l10n.languageEnglish),
          ),
          DropdownMenuItem(
            value: 'ru',
            child: Text(context.l10n.languageRussian),
          ),
        ],
      ),
    );
  }
}
