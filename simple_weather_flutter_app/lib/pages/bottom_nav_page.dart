import 'package:flutter/material.dart';
import 'package:simple_weather_flutter_app/pages/weather_page.dart';

import 'list_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  Color _selectedItemColor = Colors.blue;
  Color _unselectedItemColor = Colors.grey;

  void _navigateBottomBar(int index){
    setState(() {
      _currentIndex = index;

      _selectedItemColor = index == 0 ? Colors.blue : Colors.red;
      _unselectedItemColor = index == 0 ? Colors.grey : Colors.grey;
    });
  }

  final List _pages = [
    WeatherPage(),
    ListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateBottomBar,
        backgroundColor: Colors.yellow[200],

        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List of cities',
          ),
        ],
      ),
    );
  }
}
