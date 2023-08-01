import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Chargeablefood.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/Views/FreeFood.dart';
import 'package:satietyfrontend/pages/Views/Loginpage.dart';
import 'package:satietyfrontend/pages/Views/ListView.dart';
import 'package:satietyfrontend/pages/Messegepage.dart';
import 'package:satietyfrontend/pages/OptionPage.dart';
import 'package:satietyfrontend/pages/Views/Register.dart';
import 'package:satietyfrontend/pages/Views/SplashScreen.dart';
import 'package:satietyfrontend/pages/Views/ValidateOTP.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';
import 'pages/ViewModels/FoodListViewModel.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // var firebaseApp = await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();

  runApp(
    ChangeNotifierProvider(
      create: (_) => FoodListViewModel(),
      child: MyApp(),
    ),
  );
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
        title: 'Satiety',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          brightness: Brightness.light,
        ),
        //home: const LoginPage(),
        home: ListViewPage(),
        //home: SplashScreen(),
        routes: {
          '/ListViewPage': (context) => ListViewPage(),
          '/OptionPage': (context) => OptionPage(),
          '/AddFreeFood': (context) => AddFreeFood(),
          '/ForumPage': (context) => ForumPage(),
          '/MessegePage': (context) => MessegePage(),
          '/ChargeableFood': (context) => ChargeableFood(),
          '/Register': (context) => Register(),
          '/Login': (context) => LoginPage(),
          '/ValidateOTP': (context) => ValidateOTP(userEmail: 'abc@d.com'),
        });
  }
}
