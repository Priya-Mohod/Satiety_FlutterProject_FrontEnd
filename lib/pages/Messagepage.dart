import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:satietyfrontend/pages/Constants/SideDrawer.dart';
import 'Constants/Drawers.dart';
import 'Constants/bottomNavigationBar.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //endDrawer: SideDrawer(),
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
