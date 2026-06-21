import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/brand_logo.dart';
import 'package:flutter/material.dart';

class SidebarBrand extends StatelessWidget {
  const SidebarBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLarge,
        28,
        AppSizes.paddingLarge,
        20,
      ),
      child: Row(
        children: [
          const BrandLogo(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flow Fusion',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  context.l10n.brandSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.fusionColors.mutedForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
