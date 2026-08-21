import 'package:flow_fusion/ui/constants/social_link.dart';
import 'package:flow_fusion/ui/constants/social_links.dart';
import 'package:flow_fusion/ui/widgets/sidebar_social_link_button.dart';
import 'package:flutter/material.dart';

class SidebarSocialLinks extends StatelessWidget {
  final List<SocialLink> links;

  const SidebarSocialLinks({super.key, this.links = socialLinks});

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final SocialLink link in links)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SidebarSocialLinkButton(link: link),
          ),
      ],
    );
  }
}
