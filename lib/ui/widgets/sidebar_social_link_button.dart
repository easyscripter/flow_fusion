import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/constants/social_link.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SidebarSocialLinkButton extends StatelessWidget {
  final SocialLink link;

  const SidebarSocialLinkButton({super.key, required this.link});

  static const double _size = 32;

  @override
  Widget build(BuildContext context) {
    final colors = context.fusionColors;
    final radius = BorderRadius.circular(AppSizes.borderRadiusSmall);

    return Tooltip(
      message: link.label,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: radius),
        child: InkWell(
          onTap: () => _openLink(context),
          borderRadius: radius,
          hoverColor: colors.panelMuted,
          child: SizedBox(
            width: _size,
            height: _size,
            child: Center(
              child: FaIcon(
                link.icon,
                size: AppSizes.iconSizeSmall,
                color: colors.mutedForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openLink(BuildContext context) async {
    final uri = Uri.parse(link.url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e, s) {
      AppLogger.error('SidebarSocialLinkButton.openLink(${link.url})', e, s);
    }
  }
}
