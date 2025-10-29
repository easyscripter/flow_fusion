import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final VoidCallback onTap;
  final VoidCallback onStart;
  final VoidCallback onDelete;
  final double? maxHeight;
  final double? minHeight;
  final double? maxWidth;
  final double? minWidth;

  const SessionCard({
    super.key,
    required this.session,
    required this.onTap,
    required this.onStart,
    required this.onDelete,
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
              Text(session.name),
              Spacer(),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Иконки по правому краю
                children: [
                  IconButton(onPressed: onStart, icon: Icon(Icons.play_arrow)),
                  SizedBox(width: 8),
                  IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
