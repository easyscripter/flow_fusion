import 'package:flutter/material.dart';

class NumberStepperButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final double height;
  final double width;

  const NumberStepperButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.height = 16,
    this.width = 22,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: height,
        width: width,
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
