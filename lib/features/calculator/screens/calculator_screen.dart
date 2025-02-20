import 'package:flutter/material.dart';
import '../../../widgets/calculator_button.dart';
import 'dart:ui';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  String _expression = '';
  String _result = '0';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<String> buttons = [
    'C',
    '±',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'DEL',
    '=',
  ];

  // Pastel color scheme
  final Map<String, Color> buttonColors = {
    'C': Color(0xFFFFB5B5), // Soft pink
    '±': Color(0xFFB5E6FF), // Soft blue
    '%': Color(0xFFB5E6FF), // Soft blue
    '÷': Color(0xFFFFE2B5), // Soft orange
    '×': Color(0xFFFFE2B5), // Soft orange
    '-': Color(0xFFFFE2B5), // Soft orange
    '+': Color(0xFFFFE2B5), // Soft orange
    '=': Color(0xFFB5FFD9), // Soft green
    'DEL': Color(0xFFFFB5B5), // Soft pink
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '0';
        _animationController.forward(from: 0.0);
      } else if (value == '=') {
        try {
          // Implement calculation logic here
          _animationController.forward(from: 0.0);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _expression += value;
        _animationController.forward(from: 0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FA), // Very light gray
              Color(0xFFF1F3F5), // Light gray
              Color(0xFFE9ECEF), // Lighter gray
            ],
          ),
        ),
        child: Column(
          children: [
            // Display area with game-inspired design
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Expression display with animation
                          AnimatedBuilder(
                            animation: _fadeAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _fadeAnimation.value,
                                child: Text(
                                  _expression,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Color(0xFF6C757D),
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 12),
                          // Result display with animation
                          AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Text(
                                  _result,
                                  style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF495057),
                                    letterSpacing: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Buttons area with game-inspired design
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 - (_animationController.value * 0.1),
                          child: CalculatorButton(
                            label: buttons[index],
                            color: buttonColors[buttons[index]] ??
                                Color(0xFFF8F9FA),
                            onPressed: () => _onButtonPressed(buttons[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
