import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  final List<IconData> menuIcons;
  final List<String>? menuLabels;
  final Function(int) onDestinationSelected;
  final int selectedIndex;

  const SidebarWidget({
    Key? key,
    required this.menuIcons,
    required this.onDestinationSelected,
    this.menuLabels,
    this.selectedIndex = 0, // Default selected index
  })  : assert(menuIcons.length == menuLabels?.length || menuLabels == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<NavigationRailDestination> destinations = [];
    for (int i = 0; i < menuIcons.length; i++) {
      destinations.add(
        NavigationRailDestination(
          icon: Icon(menuIcons[i]),
          selectedIcon: Icon(menuIcons[i]),
          label: Text(menuLabels != null ? menuLabels![i] : ''),
        ),
      );
    }

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: destinations,
    );
  }
}
