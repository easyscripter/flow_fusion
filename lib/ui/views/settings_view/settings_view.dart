import 'package:flow_fusion/ui/app/app_view_model.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
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
              title: 'Настройки',
              subtitle:
                  'Базовый набор теперь ближе к shadcn: нейтральные поверхности, четкие границы и спокойный контраст.',
              trailing: const AppBadge(
                label: 'Theme',
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
                      title: 'Оформление',
                      children: [
                        Observer(builder: (_) => _buildThemeTile(context)),
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
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
                'Тема',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Text(
            'Темная тема активна по умолчанию. Светлая тема сохраняет тот же строгий компонентный стиль без ярких акцентов.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.fusionColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              AppBadge(label: 'Neutral surfaces'),
              AppBadge(label: 'Subtle borders'),
              AppBadge(label: 'Rounded corners'),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode_outlined),
                label: Text('Темная'),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode_outlined),
                label: Text('Светлая'),
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
    ThemeMode.system => Icons.dark_mode,
  };
}
