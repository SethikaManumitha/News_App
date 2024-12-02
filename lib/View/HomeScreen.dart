import 'package:flutter/material.dart';
import 'Tabs/HomeTab.dart';
import 'Tabs/SettingsTab.dart';
import 'Tabs/SearchTab.dart';
import 'Tabs/BookMarkTab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> _screens = [
    const HomeTab(),
    const SearchTab(),
    const BookMarkTab(),
    const SettingTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: _isSearchVisible
            ? TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _screens[1] = SearchTab(query: value);
            });
          },
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        )
            : const Text("News App"),
        actions: [
          if (!_isSearchVisible)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _toggleSearchBar,
            ),
          if (_isSearchVisible)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleSearchBar,
            ),
        ],
      ),
      body: _isSearchVisible ? _screens[1] : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: isDarkMode ? Colors.white : Colors.black54,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
