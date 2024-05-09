import 'package:flow_fusion/ui/views/session_view/session_view.dart';
import 'package:flow_fusion/ui/views/settings_view/settings_view.dart';
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
                Icons.schedule,
                Icons.settings,
              ],
              menuLabels: const [
                'Session',
                'Settings',
              ],
              selectedIndex: _viewModel.selectedIndex,
              onDestinationSelected: _viewModel.selectTab,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // Main content area
            Expanded(
              child: Center(
                child: switch (_viewModel.selectedIndex) {
                  0 => SessionView(currentSession: _viewModel.currentSession),
                  _ => const SettingsView(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
