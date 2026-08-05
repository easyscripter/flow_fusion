import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class TimerQueueEndStation extends StatelessWidget {
  const TimerQueueEndStation({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 128,
            height: 24,
            child: Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: colors.panelMuted,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.lineStrong, width: 3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 128,
            child: Text(
              context.l10n.timerQueueEndStation,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.mutedForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
