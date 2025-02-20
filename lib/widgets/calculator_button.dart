import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF333333),
  }) : super(key: key);

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: _isPressed ? 8 : 15,
                    spreadRadius: _isPressed ? 1 : 2,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withOpacity(0.9),
                    widget.color.withOpacity(1.0),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: Color(0xFF495057),
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
