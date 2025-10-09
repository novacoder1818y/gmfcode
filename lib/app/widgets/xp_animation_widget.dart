
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget that displays a "XP Gained" animation and then fades away.
class XpAnimationWidget extends StatelessWidget {
  final int points;
  final VoidCallback onComplete;

  const XpAnimationWidget({
    super.key,
    required this.points,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "+$points XP",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
        )
            .animate(onComplete: (controller) => onComplete())
            .fadeIn(duration: 300.ms)
            .then(delay: 1500.ms) // Hold the text on screen
            .slideY(begin: 0, end: -0.5, duration: 500.ms, curve: Curves.easeOut)
            .then()
            .fadeOut(duration: 500.ms),
      ),
    );
  }
}
