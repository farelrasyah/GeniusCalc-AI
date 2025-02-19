import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:geniuscalc_ai/core/constant/app_constants.dart';
import 'package:geniuscalc_ai/core/theme/app_theme.dart';
import 'package:geniuscalc_ai/features/calculator/screens/calculator_screen.dart';
import 'package:geniuscalc_ai/widgets/game_app_bar.dart';
import 'package:geniuscalc_ai/widgets/game_nav_bar.dart';

void main() {
  // Enable web platform with proper initialization
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // Updated method for setting URL strategy
  runApp(const SmartCalcAI());
}

class SmartCalcAI extends StatelessWidget {
  const SmartCalcAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.classicTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _userLevel = 1;
  int _userXP = 0;

  final List<Widget> _screens = [
    const CalculatorScreen(),
    const Placeholder(), // Temporary placeholder for AI Assistant
    const Placeholder(), // Temporary placeholder for Settings
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBody: true,
      appBar: GameAppBar(
        title: AppConstants.appName,
        level: _userLevel,
        xp: _userXP,
        maxXP: AppConstants.levelUpXP,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: GameNavBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          HapticFeedback.selectionClick();
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
