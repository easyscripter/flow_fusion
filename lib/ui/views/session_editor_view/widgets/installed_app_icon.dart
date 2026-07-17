import 'dart:convert';

import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class InstalledAppIcon extends StatelessWidget {
  const InstalledAppIcon({super.key, this.iconBase64, this.size});

  final String? iconBase64;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final double resolvedSize = size ?? AppSizes.iconSizeLarge;
    if (iconBase64 == null || iconBase64!.isEmpty) {
      return Icon(Icons.apps_rounded, size: resolvedSize);
    }
    return Image.memory(
      base64Decode(iconBase64!),
      width: resolvedSize,
      height: resolvedSize,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, _, _) =>
          Icon(Icons.apps_rounded, size: resolvedSize),
    );
  }
}
