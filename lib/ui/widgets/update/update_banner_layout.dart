import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/material.dart';

/// Shared chrome for every update banner state: a full-width strip with a
/// leading icon, a message, and trailing widgets (actions or progress).
class UpdateBannerLayout extends StatelessWidget {
  const UpdateBannerLayout({
    super.key,
    required this.icon,
    required this.message,
    this.trailing = const [],
  });

  final IconData icon;
  final String message;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colors.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLarge,
        vertical: 10,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
          const SizedBox(width: 12),
          for (final widget in trailing) ...[widget, const SizedBox(width: 8)],
        ],
      ),
    );
  }
}

/// Runs a controller action, logging failures. The controller also surfaces
/// failures through its own state, so the UI updates regardless.
Future<void> runUpdateAction(
  String action,
  Future<Object?> Function() task,
) async {
  try {
    await task();
  } catch (e, s) {
    AppLogger.error('UpdateBanner.$action', e, s);
  }
}
