import 'package:flow_fusion/ui/views/sessions_view/sessions_view.dart';
import 'package:flow_fusion/ui/views/settings_view/settings_view.dart';
import 'package:flow_fusion/ui/views/home_view/home_view.dart';
import 'package:flow_fusion/ui/pages/home_page/home_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _viewModel = HomePageViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) => Row(
          children: [
            NavigationDrawer(
              onDestinationSelected: _viewModel.selectTab,
              selectedIndex: _viewModel.selectedIndex,
              tilePadding: EdgeInsets.all(2),
              indicatorShape: RoundedRectangleBorder(
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
                      _viewModel.packageVersion,
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
            ),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return switch (_viewModel.selectedIndex) {
      0 => HomeView(
        onNavigate: _viewModel.selectTab,
      ), // Главная страница с навигацией
      1 => SessionsView(), // Сессии
      2 => const SettingsView(), // Настройки
      _ => HomeView(onNavigate: _viewModel.selectTab), // По умолчанию главная
    };
  }
}
