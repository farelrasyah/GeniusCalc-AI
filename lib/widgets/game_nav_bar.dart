import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class GameNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const GameNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE8F3).withOpacity(0.95),
            Color(0xFFE8F6FF).withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                0,
                Icons.calculate_rounded,
                'Calculator',
                Color(0xFFFFB5D8),
              ),
              _buildNavItem(
                1,
                Icons.psychology_rounded,
                'AI Assistant',
                Color(0xFFB5E6FF),
              ),
              _buildNavItem(
                2,
                Icons.settings_rounded,
                'Settings',
                Color(0xFFB5FFD9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color color) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTapDown: (_) => HapticFeedback.lightImpact(),
      onTap: () => onDestinationSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: -2,
                        ),
                      ]
                    : [],
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Color(0xFF495057),
                size: 22,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Color(0xFF495057),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
