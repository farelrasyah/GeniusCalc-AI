import 'package:flutter/material.dart';
import '../../../widgets/calculator_button.dart';
import 'dart:ui';
import '../../ai_assistant/screens/aiAssistantScreen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with TickerProviderStateMixin {
  String _expression = '';
  String _result = '0';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _displayOpacityAnimation;

  String _currentNumber = '';
  List<String> _operators = ['+', '-', '×', '÷', '%'];
  bool _hasDecimalPoint = false;
  bool _shouldResetInput = false;

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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _displayOpacityAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (_shouldResetInput && !_operators.contains(value)) {
        _expression = '';
        _shouldResetInput = false;
      }

      switch (value) {
        case 'C':
          _clear();
          break;
        case 'DEL':
          _delete();
          break;
        case '=':
          _calculate();
          break;
        case '.':
          _handleDecimalPoint();
          break;
        case '±':
          _toggleSign();
          break;
        case '%':
          _handlePercentage();
          break;
        default:
          if (_operators.contains(value)) {
            _handleOperator(value);
          } else {
            _handleNumber(value);
          }
      }
      _animationController.forward(from: 0.0);
    });
  }

  void _clear() {
    _expression = '';
    _result = '0';
    _currentNumber = '';
    _hasDecimalPoint = false;
    _shouldResetInput = false;
  }

  void _delete() {
    if (_expression.isNotEmpty) {
      String lastChar = _expression[_expression.length - 1];
      if (lastChar == '.') {
        _hasDecimalPoint = false;
      }
      _expression = _expression.substring(0, _expression.length - 1);
      if (_expression.isEmpty) {
        _result = '0';
      } else {
        _tryCalculate();
      }
    }
  }

  void _handleNumber(String number) {
    _expression += number;
    _currentNumber += number;
    _tryCalculate();
  }

  void _handleDecimalPoint() {
    if (!_hasDecimalPoint) {
      if (_expression.isEmpty ||
          _operators.contains(_expression[_expression.length - 1])) {
        _expression += '0';
      }
      _expression += '.';
      _currentNumber += '.';
      _hasDecimalPoint = true;
    }
  }

  void _handleOperator(String operator) {
    if (_expression.isNotEmpty) {
      String lastChar = _expression[_expression.length - 1];
      if (_operators.contains(lastChar)) {
        _expression =
            _expression.substring(0, _expression.length - 1) + operator;
      } else {
        _expression += operator;
      }
      _currentNumber = '';
      _hasDecimalPoint = false;
    } else if (operator == '-' && _expression.isEmpty) {
      _expression = operator;
      _currentNumber = operator;
    }
  }

  void _toggleSign() {
    if (_expression.isNotEmpty) {
      if (_expression[0] == '-') {
        _expression = _expression.substring(1);
      } else {
        _expression = '-' + _expression;
      }
      _tryCalculate();
    }
  }

  void _handlePercentage() {
    if (_expression.isNotEmpty &&
        !_operators.contains(_expression[_expression.length - 1])) {
      try {
        double number = double.parse(_currentNumber);
        number = number / 100;
        String newExpression = _expression.substring(
            0, _expression.length - _currentNumber.length);
        _expression = newExpression + number.toString();
        _currentNumber = number.toString();
        _tryCalculate();
      } catch (e) {
        _result = 'Error';
      }
    }
  }

  // Format number to remove .0 if the number is whole
  String _formatResult(String numberStr) {
    if (numberStr == 'Error') return numberStr;

    try {
      double number = double.parse(numberStr);
      if (number == number.toInt()) {
        return number.toInt().toString();
      }
      return numberStr;
    } catch (e) {
      return numberStr;
    }
  }

  void _calculate() {
    try {
      _result = _formatResult(_evaluateExpression(_expression).toString());
      _shouldResetInput = true;
    } catch (e) {
      _result = 'Error';
    }
  }

  void _tryCalculate() {
    try {
      _result = _formatResult(_evaluateExpression(_expression).toString());
    } catch (e) {
      // Silently fail for partial expressions
    }
  }

  double _evaluateExpression(String expression) {
    if (expression.isEmpty) return 0;

    // Replace × and ÷ with * and / for evaluation
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

    // Handle parentheses and operator precedence
    List<String> tokens = _tokenize(expression);
    return _evaluateTokens(tokens);
  }

  List<String> _tokenize(String expression) {
    List<String> tokens = [];
    String number = '';

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if (char.contains(RegExp(r'[0-9.]'))) {
        number += char;
      } else {
        if (number.isNotEmpty) {
          tokens.add(number);
          number = '';
        }
        tokens.add(char);
      }
    }
    if (number.isNotEmpty) {
      tokens.add(number);
    }

    return tokens;
  }

  double _evaluateTokens(List<String> tokens) {
    // Handle multiplication and division first
    for (int i = 1; i < tokens.length - 1; i += 2) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        double a = double.parse(tokens[i - 1]);
        double b = double.parse(tokens[i + 1]);
        double result;
        if (tokens[i] == '*') {
          result = a * b;
        } else {
          if (b == 0) throw Exception('Division by zero');
          result = a / b;
        }
        tokens[i - 1] = result.toString();
        tokens.removeRange(i, i + 2);
        i -= 2;
      }
    }

    // Handle addition and subtraction
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length - 1; i += 2) {
      double b = double.parse(tokens[i + 1]);
      if (tokens[i] == '+') {
        result += b;
      } else if (tokens[i] == '-') {
        result -= b;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF0F4F8), // Very soft blue-gray
                  Color(0xFFF8F9FA), // Soft white
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildDisplayArea(),
                ),
                SizedBox(height: 20),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
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
                                onPressed: () =>
                                    _onButtonPressed(buttons[index]),
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
          // AI Assistant Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            child: TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 1200),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AIAssistantScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFB5E6FF),
                            Color(0xFF19A7CE),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFB5E6FF).withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final adaptiveHeight = constraints.maxHeight * 0.75;

          return Container(
            constraints: BoxConstraints(
              maxHeight: adaptiveHeight,
              minHeight: 150,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFAFD3E2).withOpacity(0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                  spreadRadius: -5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE3F4F4), // Very soft cyan
                        Colors.white,
                        Color(0xFFD4F1F4), // Soft sky blue
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [_fadeAnimation, _displayOpacityAnimation]),
                        builder: (context, child) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFD4F1F4).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Color(0xFFAFD3E2).withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              _expression.isEmpty ? '0' : _expression,
                              style: TextStyle(
                                fontSize: 28,
                                color: Color(0xFF19A7CE), // Soft blue text
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.5,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [_scaleAnimation, _displayOpacityAnimation]),
                        builder: (context, child) {
                          return Container(
                            constraints: BoxConstraints(
                              minHeight: 90,
                              minWidth: double.infinity,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFE3F4F4).withOpacity(0.5),
                                  Colors.white.withOpacity(0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFAFD3E2).withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                  spreadRadius: -3,
                                ),
                              ],
                            ),
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Text(
                                _result,
                                style: TextStyle(
                                  fontSize: _result.length > 8 ? 46 : 58,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF146C94), // Darker soft blue
                                  letterSpacing: 2.5,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
