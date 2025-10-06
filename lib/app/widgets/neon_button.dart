// lib/app/widgets/neon_button.dart
import 'package:flutter/material.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final List<Color> gradientColors;

  const NeonButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    required this.gradientColors,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: widget.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: !_isPressed
              ? [
            BoxShadow(
              color: widget.gradientColors.first.withOpacity(0.7),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(-4, -4),
            ),
            BoxShadow(
              color: widget.gradientColors.last.withOpacity(0.7),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(4, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: Colors.white),
              const SizedBox(width: 10),
            ],
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}