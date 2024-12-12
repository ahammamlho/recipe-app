import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipe/screens/add_recipe.dart';
import 'package:recipe/screens/page_home.dart';
import 'package:recipe/screens/profile_screen.dart';

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AddRecipe(),
    const Center(child: Text("favorite Page", style: TextStyle(fontSize: 24))),
    const PageHome(),
    const Center(
        child: Text("notifications Page", style: TextStyle(fontSize: 24))),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: 5),
          color: Colors.blueAccent,
          child: CurvedNavigationBar(
            backgroundColor: Colors.blueAccent,
            items: const <Widget>[
              Icon(Icons.add, size: 20),
              Icon(Icons.favorite, size: 20),
              Icon(Icons.home, size: 20),
              Icon(Icons.notifications, size: 20),
              Icon(Icons.account_circle, size: 20),
            ],
            index: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ));
  }
}
