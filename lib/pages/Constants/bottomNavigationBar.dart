import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 40),
          label: 'Home',
          backgroundColor: Colors.cyan,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum_outlined, size: 40),
          label: 'Forum',
          backgroundColor: Colors.cyan,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 70),
          label: 'Add',
          backgroundColor: Colors.cyan,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.ads_click, size: 40),
          label: 'Ads',
          backgroundColor: Colors.cyan,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.email, size: 40),
          label: 'Messeges',
          backgroundColor: Colors.cyan,
        ),
      ],
    );
  }
}
