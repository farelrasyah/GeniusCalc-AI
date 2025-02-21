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
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE8F3).withOpacity(0.95),
            Color(0xFFE8F6FF).withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 5),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  0,
                  'assets/icons/calculator.png', // Replace with your custom icon
                  Icons.calculate_rounded,
                  'Calculator',
                  Color(0xFFFFB5D8),
                ),
                _buildNavItem(
                  1,
                  'assets/icons/ai_brain.png', // Replace with your custom icon
                  Icons.auto_awesome_rounded,
                  'AI Magic',
                  Color(0xFFB5E6FF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, IconData defaultIcon,
      String label, Color color) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTapDown: (_) => HapticFeedback.lightImpact(),
      onTap: () => onDestinationSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.all(isSelected ? 12 : 8),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: -2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                defaultIcon,
                color: isSelected ? Colors.white : Color(0xFF495057),
                size: isSelected ? 24 : 22,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 12),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color: Color(0xFF495057),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
