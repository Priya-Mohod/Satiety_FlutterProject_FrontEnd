import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Chargeablefood.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/FreeFood.dart';
import 'package:satietyfrontend/pages/Loginpage.dart';
import 'package:satietyfrontend/pages/ListView.dart';
import 'package:satietyfrontend/pages/Messegepage.dart';
import 'package:satietyfrontend/pages/OptionPage.dart';
import 'package:satietyfrontend/pages/Register.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // var firebaseApp = await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: _firebaseAnalytics),
        ],
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          brightness: Brightness.light,
        ),
        //home: const Register(),
        //home: ListViewPage(),
        home: LoginPage(),
        routes: {
          '/ListViewPage': (context) => ListViewPage(),
          '/OptionPage': (context) => OptionPage(),
          '/AddFreeFood': (context) => AddFreeFood(),
          '/ForumPage': (context) => ForumPage(),
          '/MessegePage': (context) => MessegePage(),
          '/ChargeableFood': (context) => ChargeableFood(),
          '/Register': (context) => Register(),
          '/Login': (context) => LoginPage(),
        });
  }
}
