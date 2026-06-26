import 'package:flutter/material.dart';
import '../widgets/quote_icon.dart';
import 'home_screen.dart';
import 'quotes_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    QuotesListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF5AB2FF),
        unselectedItemColor: Colors.grey,
        iconSize: 28,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: SizedBox(height: 28, child: Icon(Icons.home, size: 28)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Padding(padding: EdgeInsets.only(top: 4), child: SizedBox(height: 28, width: 28, child: Center(child: QuoteIcon(color: Colors.grey, size: 28)))),
            activeIcon: const Padding(padding: EdgeInsets.only(top: 4), child: SizedBox(height: 28, width: 28, child: Center(child: QuoteIcon(color: Color(0xFF5AB2FF), size: 28)))),
            label: 'Quotes',
          ),
        ],
      ),
    );
  }
}
