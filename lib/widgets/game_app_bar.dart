import 'package:flutter/material.dart';
import 'dart:ui';

class GameAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final int level;
  final int xp;
  final int maxXP;

  const GameAppBar({
    Key? key,
    required this.title,
    required this.level,
    required this.xp,
    required this.maxXP,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  State<GameAppBar> createState() => _GameAppBarState();
}

class _GameAppBarState extends State<GameAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.xp / widget.maxXP,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F3FF).withOpacity(0.95), // Soft blue
            Color(0xFFFFF0F3).withOpacity(0.95), // Soft pink
          ],
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildAnimatedLevelBadge(),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTitleArea()),
                      _buildXPBadge(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildAnimatedProgressBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLevelBadge() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFB5D8), // Soft pink
                  Color(0xFFB5E6FF), // Soft blue
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFFB5D8).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.level}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: Color(0xFF495057),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          'Level ${widget.level} Explorer',
          style: TextStyle(
            color: Color(0xFF6C757D),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildXPBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
        ),
      ),
      child: Text(
        '${widget.xp}/${widget.maxXP} XP',
        style: TextStyle(
          color: Color(0xFF495057),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAnimatedProgressBar() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth * _progressAnimation.value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFB5D8), // Soft pink
                          Color(0xFFB5E6FF), // Soft blue
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFB5D8).withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        10,
                        (index) => Container(
                          width: 1,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
