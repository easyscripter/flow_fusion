import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flutter/material.dart';

/// Inline error state with a retry action, shown when a screen-level load fails.
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: AppSizes.iconSizeLarge,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSizes.paddingSmall),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.errorRetry),
          ),
        ],
      ),
    );
  }
}
