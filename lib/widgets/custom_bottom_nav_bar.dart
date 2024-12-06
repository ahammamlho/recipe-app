import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      color: Colors.blueAccent,
      child: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        items: const <Widget>[
          Icon(Icons.add, size: 20),
          Icon(Icons.list, size: 20),
          Icon(Icons.compare_arrows, size: 20),
          Icon(Icons.usb_rounded, size: 20),
        ],
        onTap: (index) {
          
        },
      ),
    );
  }
}
