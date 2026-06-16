import 'package:flow_fusion/enums/routes.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/widgets/app_badge.dart';
import 'package:flow_fusion/ui/widgets/app_button.dart';
import 'package:flow_fusion/ui/widgets/app_page_header.dart';
import 'package:flow_fusion/ui/widgets/quick_action_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  final double? cardMaxHeight;
  final double? cardMinHeight;
  final double? gridSpacing;
  final double? childAspectRatio;
  final int? defaultCrossAxisCount;

  const HomeView({
    super.key,
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
            AppPageHeader(
              title: 'Рабочее пространство',
              subtitle:
                  'Минималистичный интерфейс в стиле shadcn для спокойной работы с фокус-сессиями и повседневными ритуалами.',
              trailing: const AppBadge(
                label: 'shadcn-like',
                icon: Icons.layers_outlined,
              ),
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            Wrap(
              spacing: AppSizes.paddingMedium,
              runSpacing: AppSizes.paddingMedium,
              children: [
                AppButton(
                  label: 'Открыть сессии',
                  icon: Icons.schedule_rounded,
                  onPressed: () => context.go(Routes.sessions.path),
                ),
                AppButton(
                  label: 'Настройки темы',
                  icon: Icons.tune_rounded,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.go(Routes.settings.path),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount =
                      defaultCrossAxisCount ?? AppSizes.defaultCrossAxisCount;
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
                    childAspectRatio:
                        childAspectRatio ?? AppSizes.childAspectRatio,
                    children: [
                      QuickActionCard(
                        icon: const Icon(Icons.schedule_rounded),
                        title: 'Сессии фокуса',
                        subtitle:
                            'Откройте сценарии, просмотрите фазы и переходите к следующему циклу без лишнего шума.',
                        maxHeight: cardMaxHeight,
                        minHeight: cardMinHeight,
                        onTap: () => context.go(Routes.sessions.path),
                      ),
                      QuickActionCard(
                        icon: const Icon(Icons.tune_rounded),
                        title: 'Тема и поведение',
                        subtitle:
                            'Меняйте светлую и темную тему, сохраняя тот же строгий и спокойный визуальный язык.',
                        maxHeight: cardMaxHeight,
                        minHeight: cardMinHeight,
                        onTap: () => context.go(Routes.settings.path),
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
