import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/ViewModels/LoginViewModel.dart';
import 'package:satietyfrontend/pages/Views/FreeFood.dart';
import 'package:satietyfrontend/pages/Views/Loginpage.dart';
import 'package:satietyfrontend/pages/Views/ListView.dart';
import 'package:satietyfrontend/pages/Messegepage.dart';
import 'package:satietyfrontend/pages/Views/Profile.dart';
import 'package:satietyfrontend/pages/Views/Register.dart';
import 'package:satietyfrontend/pages/Views/SplashScreen.dart';
import 'package:satietyfrontend/pages/Views/SupplierLocationMap.dart';
import 'package:satietyfrontend/pages/Views/ValidateOTP.dart';
import 'package:satietyfrontend/pages/Constants/Drawers.dart';
import 'package:satietyfrontend/pages/Views/MyListing.dart';
import 'package:satietyfrontend/pages/Views/MyRequests.dart';
import 'package:satietyfrontend/pages/Views/sample.dart';
import 'package:satietyfrontend/pages/ViewModels/requestProvider.dart';
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

  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FoodListViewModel(),
        ),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
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
        home: const LoginPage(),
        routes: {
          '/ListViewPage': (context) => ListViewPage(),
          '/AddFreeFood': (context) => AddFreeFood(),
          '/ForumPage': (context) => ForumPage(),
          '/MessegePage': (context) => MessegePage(),
          '/Register': (context) => Register(),
          '/Login': (context) => LoginPage(),
          '/ValidateOTP': (context) => ValidateOTP(userEmail: 'abc@d.com'),
          '/myList': (context) => MyFoodListing(),
          '/myRequests': (context) => MyRequests(),
          '/SupplierLocationMap': (context) =>
              SupplierLocationMap(selectedLocation: LatLng(0, 0)),
          '/Profile': (context) => UserProfile(),
        });
  }
}
