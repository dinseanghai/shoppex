import 'package:flutter/material.dart';

class IconAnimation extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final Duration duration;

  const IconAnimation({
    super.key,
    required this.icon,
    this.color = Colors.green,
    this.size = 62.0,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<IconAnimation> createState() => _BouncyIconAnimationState();
}

class _BouncyIconAnimationState extends State<IconAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration, // Dynamically uses the passed duration
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Your great bouncy effect
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(
        widget.icon, // Dynamically injected icon
        color: widget.color, // Dynamically injected color
        size: widget.size, // Dynamically injected size
      ),
    );
  }
}