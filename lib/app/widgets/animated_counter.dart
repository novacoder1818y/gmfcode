import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final int end;
  final Duration duration;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    required this.end,
    this.duration = const Duration(seconds: 1),
    this.style,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = _controller;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          (_animation.value * widget.end).toInt().toString(),
          style: widget.style,
        );
      },
    );
  }
}
