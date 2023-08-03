import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
//import 'Constatnts/endDrawer.dart';
import 'Constatnts/bottomdrawer.dart';

class MessegePage extends StatefulWidget {
  const MessegePage({super.key});

  @override
  State<MessegePage> createState() => _MessegePageState();
}

class _MessegePageState extends State<MessegePage> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messeges',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      //endDrawer: CustomEndDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40),
            label: 'Home',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum, size: 40),
            label: 'Forum',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: 'Add',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, size: 40),
            label: 'Bookmarks',
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 40),
            label: 'Messeges',
            backgroundColor: Colors.cyan,
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/ListViewPage');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/ForumPage');
          } else if (index == 2) {
            BottomDrawer.showBottomDrawer(context);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/BookmarksPage');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/MessegePage');
          }
        },
      ),
      body: Center(),
    );
  }
}
