// lib/app/widgets/animated_glow_card.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedGlowCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  const AnimatedGlowCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.gradientColors = const [AppTheme.accentColor, AppTheme.secondaryColor],
  });

  @override
  State<AnimatedGlowCard> createState() => _AnimatedGlowCardState();
}

class _AnimatedGlowCardState extends State<AnimatedGlowCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: widget.gradientColors.first.withOpacity(0.7),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 50, color: Colors.white),
              const SizedBox(height: 15),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}