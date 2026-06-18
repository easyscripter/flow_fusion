import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/widgets/brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;

    return GestureDetector(
      onPanStart: (details) {
        windowManager.startDragging();
      },
      child: Container(
        height: preferredSize.height,
        decoration: BoxDecoration(
          color: colors.sidebarBackground,
          border: Border(
            bottom: BorderSide(color: colors.sidebarBorder, width: 1),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const BrandLogo(size: 20),
            const SizedBox(width: 8),
            Text(
              'Flow Fusion',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colors.mutedForeground,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (Theme.of(context).platform == TargetPlatform.windows)
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.minimize,
                      color: colors.mutedForeground,
                      size: 16,
                    ),
                    onPressed: () => windowManager.minimize(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.crop_square,
                      color: colors.mutedForeground,
                      size: 16,
                    ),
                    onPressed: () async {
                      if (await windowManager.isMaximized()) {
                        windowManager.unmaximize();
                      } else {
                        windowManager.maximize();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: colors.mutedForeground,
                      size: 16,
                    ),
                    onPressed: () => windowManager.close(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
