import 'package:flutter/material.dart';
import 'package:flow_fusion/ui/widgets/quick_action_card.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';

class HomeView extends StatelessWidget {
  final Function(int) onNavigate;
  final double? cardMaxHeight;
  final double? cardMinHeight;
  final double? gridSpacing;
  final double? childAspectRatio;
  final int? defaultCrossAxisCount;

  const HomeView({
    super.key,
    required this.onNavigate,
    this.cardMaxHeight,
    this.cardMinHeight,
    this.gridSpacing,
    this.childAspectRatio,
    this.defaultCrossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок страницы
            Text(
              'Добро пожаловать в Flow Fusion',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            
            // Карточки с быстрыми действиями
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Определяем количество колонок в зависимости от ширины
                  int crossAxisCount = defaultCrossAxisCount ?? AppSizes.defaultCrossAxisCount;
                  if (constraints.maxWidth > 800) {
                    crossAxisCount = 3;
                  }
                  if (constraints.maxWidth > 1200) {
                    crossAxisCount = 4;
                  }
                  
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: gridSpacing ?? AppSizes.gridSpacing,
                    mainAxisSpacing: gridSpacing ?? AppSizes.gridSpacing,
                    childAspectRatio: childAspectRatio ?? AppSizes.childAspectRatio,
                    children: [
                      QuickActionCard(
                        icon: Icons.schedule,
                        title: 'Мои сессии',
                        color: Colors.green,
                        maxHeight: cardMaxHeight,
                        minHeight: cardMinHeight,
                        onTap: () => onNavigate(1), // Переход к сессиям
                      ),
                      QuickActionCard(
                        icon: Icons.settings_outlined,
                        title: 'Настройки',
                        color: Colors.purple,
                        maxHeight: cardMaxHeight,
                        minHeight: cardMinHeight,
                        onTap: () => onNavigate(2), // Переход к настройкам
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
