import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:satietyfrontend/pages/Constants/SideDrawer.dart';
import 'Constants/Drawers.dart';
import 'Constants/bottomNavigationBar.dart';

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
      endDrawer: SideDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            'Here, you can see list of your conversation with supplier/consumer.\n\n\n Site under developement.',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
