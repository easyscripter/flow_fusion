import 'package:flow_fusion/enums/phase_type.dart';
import 'package:flutter/material.dart';

class PhaseWidget extends StatelessWidget {
  final int number;
  final Color color;
  final String title;
  final PhaseType type;
  final Duration duration;
  final double width;

  const PhaseWidget({
    super.key,
    this.width = 300.0,
    required this.number,
    required this.color,
    required this.title,
    required this.type,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: color,
          width: 1.0,
        ),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color,
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Icon(
            type == PhaseType.work ? Icons.work : Icons.coffee,
            color: color,
          ),
          const SizedBox(width: 12.0),
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16.0),
          Text(
            '${duration.inMinutes} min',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
