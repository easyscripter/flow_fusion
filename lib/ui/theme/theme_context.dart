import 'package:flow_fusion/ui/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  FlowFusionColors get fusionColors =>
      Theme.of(this).extension<FlowFusionColors>()!;
}
