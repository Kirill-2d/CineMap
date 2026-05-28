import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/search_screen.dart';
import 'screens/map_screen.dart';
import 'screens/challenges_screen.dart';
import 'screens/collection_screen.dart';

void main() {
  runApp(const ProviderScope(child: CineMapApp()));
}

class CineMapApp extends StatelessWidget {
  const CineMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineMap',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 1; // Start on Search

  final _screens = const [
    MapScreen(),
    SearchScreen(),
    ChallengesScreen(),
    CollectionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: AppTheme.primary.withOpacity(0.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: AppTheme.primary),
            label: 'Карта',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search, color: AppTheme.primary),
            label: 'Поиск',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events, color: AppTheme.primary),
            label: 'Челленджи',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark, color: AppTheme.primary),
            label: 'Коллекция',
          ),
        ],
      ),
    );
  }
}
