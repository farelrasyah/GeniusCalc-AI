import 'package:flutter/material.dart';
import 'package:geniuscalc_ai/core/constant/app_constants.dart';
import 'package:geniuscalc_ai/core/theme/app_theme.dart';
import 'package:geniuscalc_ai/features/calculator/screens/calculator_screen.dart';

void main() {
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
  // Changed from _MyHomePageState
  int _currentIndex = 0;
  int _userLevel = 1;
  int _userXP = 0;

  final List<Widget> _screens = [
    const CalculatorScreen(),
    // Add AI Assistant Screen here when implemented
    // Add Profile/Settings Screen here when implemented
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          // XP and Level Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'Level $_userLevel',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text('XP: $_userXP/${AppConstants.levelUpXP}'),
              ],
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble),
            label: 'AI Assistant',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
