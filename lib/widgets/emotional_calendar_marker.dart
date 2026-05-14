import 'package:flutter/material.dart';

class EmotionalCalendarMarker extends StatelessWidget {
  const EmotionalCalendarMarker({super.key, required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors.take(3).map((color) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      }).toList(),
    );
  }
}
