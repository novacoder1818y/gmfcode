import 'package:flutter/material.dart';


class NeonButton extends StatefulWidget {
  final String text;
  // The onTap callback is now nullable to support a disabled state.
  final VoidCallback? onTap;
  final IconData? icon;
  final List<Color> gradientColors;

  const NeonButton({
    super.key,
    required this.text,
    this.onTap, // It can now be null.
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
    // Determine if the button is disabled based on the onTap callback.
    final bool isDisabled = widget.onTap == null;

    return GestureDetector(
      // Only handle tap events if the button is not disabled.
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          // If disabled, show grey colors; otherwise, show the provided gradient.
          gradient: LinearGradient(
            colors: isDisabled ? [Colors.grey[700]!, Colors.grey[800]!] : widget.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: !_isPressed && !isDisabled
              ? [
            BoxShadow(
              color: widget.gradientColors.first.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: widget.gradientColors.last.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: Colors.white),
              const SizedBox(width: 10),
            ],
            Text(
              widget.text,
              style: TextStyle(
                // If disabled, show a dimmer text color.
                color: isDisabled ? Colors.white54 : Colors.white,
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