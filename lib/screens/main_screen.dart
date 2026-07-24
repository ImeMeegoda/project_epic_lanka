import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/quote_storage_service.dart';
import '../widgets/quote_icon.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'quotes_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _favoriteCount = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    QuotesListScreen(),
    FavoritesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _refreshFavoriteCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshFavoriteCount();
  }

  Future<void> _refreshFavoriteCount() async {
    final count = await context.read<QuoteStorageService>().getFavoriteCount();
    if (!mounted) {
      return;
    }
    setState(() {
      _favoriteCount = count;
    });
  }

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
            icon: const Padding(
              padding: EdgeInsets.only(top: 4),
              child: SizedBox(
                height: 28,
                width: 28,
                child: Center(child: QuoteIcon(color: Colors.grey, size: 28)),
              ),
            ),
            activeIcon: const Padding(
              padding: EdgeInsets.only(top: 4),
              child: SizedBox(
                height: 28,
                width: 28,
                child: Center(
                  child: QuoteIcon(color: Color(0xFF5AB2FF), size: 28),
                ),
              ),
            ),
            label: 'Quotes',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.favorite_border),
                if (_favoriteCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_favoriteCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.favorite),
                if (_favoriteCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_favoriteCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
