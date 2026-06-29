import 'package:flow_fusion/model/entity/database/session.dart';
import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/widgets/session_card.dart';
import 'package:flutter/material.dart';

/// Адаптивная сетка карточек сессий.
class SessionsGrid extends StatelessWidget {
  final List<Session> sessions;
  final ValueChanged<Session> onOpen;
  final ValueChanged<Session> onStart;
  final ValueChanged<Session> onDelete;

  const SessionsGrid({
    super.key,
    required this.sessions,
    required this.onOpen,
    required this.onStart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = AppSizes.defaultCrossAxisCount;
        if (constraints.maxWidth > 800) {
          crossAxisCount = 3;
        }
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSizes.gridSpacing,
            mainAxisSpacing: AppSizes.gridSpacing,
            childAspectRatio: AppSizes.childAspectRatio,
          ),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return SessionCard(
              key: ValueKey(session.id),
              session: session,
              onTap: () => onOpen(session),
              onStart: () => onStart(session),
              onDelete: () => onDelete(session),
            );
          },
        );
      },
    );
  }
}
