import 'package:flutter/material.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';

class SidebarWidget extends StatelessWidget {
  final List<IconData> menuIcons;
  final List<String>? menuLabels;
  final Function(int) onDestinationSelected;
  final int selectedIndex;
  final double? width;
  final double? minWidth;
  final double? maxWidth;

  const SidebarWidget({
    super.key,
    required this.menuIcons,
    required this.onDestinationSelected,
    this.menuLabels,
    this.selectedIndex = 0, // Default selected index
    this.width,
    this.minWidth,
    this.maxWidth,
  }) : assert(menuIcons.length == menuLabels?.length || menuLabels == null);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth ?? AppSizes.sidebarMinWidth,
        maxWidth: maxWidth ?? AppSizes.sidebarMaxWidth,
      ),
      width: width ?? AppSizes.sidebarWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Заголовок приложения
          _buildAppHeader(context),
          
          // Разделитель
          Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            height: 1,
          ),
          
          // Навигационное меню
          Expanded(
            child: _buildNavigationMenu(context),
          ),
          
          // Нижняя часть сайдбара (можно добавить дополнительную информацию)
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingLarge),
      child: Text(
        'Flow Fusion',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildNavigationMenu(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingSmall),
      children: [
        for (int i = 0; i < menuIcons.length; i++)
          _buildNavigationItem(
            context,
            icon: menuIcons[i],
            label: menuLabels != null ? menuLabels![i] : '',
            isSelected: selectedIndex == i,
            onTap: () => onDestinationSelected(i),
          ),
      ],
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium, vertical: AppSizes.paddingSmall),
            decoration: BoxDecoration(
              color: isSelected 
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: AppSizes.iconSizeMedium,
                  color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis, // Обрезаем текст если не помещается
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Column(
        children: [
          Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            height: 1,
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Text(
            'v0.1.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
