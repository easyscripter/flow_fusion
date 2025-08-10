import 'package:flow_fusion/ui/views/session_view/session_view.dart';
import 'package:flow_fusion/ui/views/settings_view/settings_view.dart';
import 'package:flow_fusion/ui/views/home_view/home_view.dart';
import 'package:flow_fusion/ui/widgets/sidebar_widget.dart';
import 'package:flow_fusion/ui/pages/home_page/home_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
            SidebarWidget(
              menuIcons: const [
                Icons.home_outlined,      // Главная
                Icons.schedule_outlined,  // Сессии
                Icons.settings_outlined,  // Настройки
              ],
              menuLabels: const [
                'Главная',
                'Сессии',
                'Настройки',
              ],
              selectedIndex: _viewModel.selectedIndex,
              onDestinationSelected: _viewModel.selectTab,
            ),
            
            
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return switch (_viewModel.selectedIndex) {
      0 => HomeView(onNavigate: _viewModel.selectTab), // Главная страница с навигацией
      1 => SessionView(currentSession: _viewModel.currentSession), // Сессии
      2 => const SettingsView(),               // Настройки
      _ => HomeView(onNavigate: _viewModel.selectTab), // По умолчанию главная
    };
  }
}
