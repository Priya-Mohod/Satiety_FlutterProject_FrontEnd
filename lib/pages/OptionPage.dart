import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:satietyfrontend/pages/Chargeablefood.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/FreeFood.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Options',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black,
                shadowColor: Colors.red,
                elevation: 15,
                minimumSize: const Size(350, 100),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFreeFood(),
                    ));
              },
              child: const Text('Free Food', style: TextStyle(fontSize: 40)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black,
                shadowColor: Colors.red,
                elevation: 15,
                minimumSize: const Size(350, 100),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChargeableFood(),
                    ));
              },
              child:
                  const Text('Chargeable Food', style: TextStyle(fontSize: 40)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black,
                shadowColor: Colors.red,
                elevation: 15,
                minimumSize: const Size(350, 100),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForumPage(),
                    ));
              },
              child: const Text('Forum', style: TextStyle(fontSize: 40)),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Help!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'times new roman',
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForumPage(),
                          ));
                    },
                    child: const Text(
                      " What I can add?",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 27,
                        fontFamily: 'verdana',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
