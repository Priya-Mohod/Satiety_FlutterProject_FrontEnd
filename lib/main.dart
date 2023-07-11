import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Chargeablefood.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/FreeFood.dart';
import 'package:satietyfrontend/pages/Loginpage.dart';
import 'package:satietyfrontend/pages/ListView.dart';
import 'package:satietyfrontend/pages/Messegepage.dart';
import 'package:satietyfrontend/pages/OptionPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        brightness: Brightness.light,
      ),
      home: ListViewPage(),
      //LoginPage(),
      routes: {
        '/ListViewPage': (context) => ListViewPage(),
        '/OptionPage': (context) => OptionPage(),
        '/AddFreeFood': (context) => AddFreeFood(),
        '/ForumPage': (context) => ForumPage(),
        '/MessegePage': (context) => MessegePage(),
        '/ChargeableFood': (context) => ChargeableFood(),
      },
    );
  }
}
