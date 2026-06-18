import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  final double size;

  const BrandLogo({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.borderRadiusSmall);
    return ClipRRect(
      borderRadius: radius,
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              'F',
              style: TextStyle(
                fontSize: size * 0.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
