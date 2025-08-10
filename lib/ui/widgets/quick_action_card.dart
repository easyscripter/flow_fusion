import 'package:flutter/material.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final double? maxHeight;
  final double? minHeight;
  final double? maxWidth;
  final double? minWidth;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.maxHeight,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? AppSizes.cardMaxHeight,
            minHeight: minHeight ?? AppSizes.cardMinHeight,
            maxWidth: maxWidth ?? AppSizes.cardMaxWidth,
            minWidth: minWidth ?? AppSizes.cardMinWidth,
          ),
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Карточка занимает минимум места
            children: [
              Icon(
                icon,
                size: AppSizes.iconSizeLarge,
                color: color,
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis, // Обрезаем текст если не помещается
                  maxLines: 2, // Максимум 2 строки
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
