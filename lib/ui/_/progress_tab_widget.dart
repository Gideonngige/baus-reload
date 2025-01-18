import 'package:flutter/material.dart';

class ProgressTabWidget extends StatelessWidget {
  final bool enabled;
  final int position;
  final Color color;

  const ProgressTabWidget({
    super.key,
    required this.enabled,
    required this.position,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          '$position',
          style: TextStyle(
            color: enabled ? color : Colors.white,
          ),
        ),
      );
}
