import 'package:flow_fusion/gen/assets.gen.dart';
import 'package:flow_fusion/model/datasources/local/prefs.dart';
import 'package:flow_fusion/ui/pages/session_page/session_page.dart';
import 'package:flow_fusion/ui/pages/settings_page/settings_page.dart';
import 'package:flow_fusion/ui/widgets/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const SessionPage(),
    const SettingsPage(),
  ];
  void initState() {
    super.initState();

    final prefs = GetIt.instance.get<Prefs>();
    prefs.buckets = 1;
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: [
      SidebarWidget(
        menuIcons: const [Icons.schedule, Icons.settings],
        menuLabels: const ['Session', 'Settings'],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
      const VerticalDivider(thickness: 1, width: 1),
      // Main content area
      Expanded(
        child: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
      ),
    ]));
  }
}
