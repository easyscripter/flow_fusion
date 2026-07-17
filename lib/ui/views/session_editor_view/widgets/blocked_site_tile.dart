import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flutter/material.dart';

class BlockedSiteTile extends StatelessWidget {
  const BlockedSiteTile({
    super.key,
    required this.domain,
    required this.onRemove,
  });

  final String domain;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: context.fusionColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        border: Border.all(color: context.fusionColors.cardBorder),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.public_rounded,
            size: AppSizes.iconSizeMedium,
            color: context.fusionColors.mutedForeground,
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          Expanded(
            child: Text(
              domain,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: context.l10n.sessionEditorRemoveBlockedSite,
            icon: Icon(
              Icons.close_rounded,
              size: AppSizes.iconSizeSmall,
              color: context.fusionColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
