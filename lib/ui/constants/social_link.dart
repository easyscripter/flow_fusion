import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class SocialLink {
  final FaIconData icon;
  final String label;
  final String url;

  const SocialLink({
    required this.icon,
    required this.label,
    required this.url,
  });
}
