import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:satietyfrontend/pages/AdvertisePage.dart';
import 'package:satietyfrontend/pages/Constants/SelectedPageProvider.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/Screens/AddressSelectionScreen.dart';
import 'package:satietyfrontend/pages/Screens/LoginScreen.dart';
import 'package:satietyfrontend/pages/Screens/RootScreen.dart';
import 'package:satietyfrontend/pages/Screens/UserAccountScreen.dart';
import 'package:satietyfrontend/pages/Screens/VerifyOTPScreen.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/ViewModels/ChatViewModel.dart';
import 'package:satietyfrontend/pages/ViewModels/LoginViewModel.dart';
import 'package:satietyfrontend/pages/Views/ChatPage.dart';
import 'package:satietyfrontend/pages/Views/CustomBottomBar.dart';
import 'package:satietyfrontend/pages/Views/FreeFood.dart';
import 'package:satietyfrontend/pages/Views/Loginpage.dart';
import 'package:satietyfrontend/pages/Views/ListView.dart';
import 'package:satietyfrontend/pages/Messagepage.dart';
import 'package:satietyfrontend/pages/Views/MyListings.dart';
import 'package:satietyfrontend/pages/Views/PublicProfile.dart';
import 'package:satietyfrontend/pages/Views/Register.dart';
import 'package:satietyfrontend/pages/Views/SupplierLocationMap.dart';
import 'package:satietyfrontend/pages/Views/UserProfile.dart';
import 'package:satietyfrontend/pages/Views/ValidateOTP.dart';
import 'package:satietyfrontend/pages/Views/MyRequests.dart';
import 'package:satietyfrontend/pages/ViewModels/requestProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'pages/Screens/HomeScreen.dart';
import 'pages/ViewModels/FoodListViewModel.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodListViewModel()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SelectedPageProvider()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: MyApp(),
    ),
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;
  // This widget is the root of your application.
  bool isLoggedIn = true;

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
        home: FutureBuilder<Widget?>(
          future: getFirstPage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is still loading, return a loading indicator or placeholder
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Handle errors
              return Text('Landing Page Error: ${snapshot.error}');
            } else {
              // Future is complete, return the determined landing page
              return snapshot.data ??
                  LoginPage(); // Use LoginPage as a default if data is null
              //return CustomBottomBar();
            }
          },
        ),
        //home: ListViewPage(),
        routes: {
          '/AddressSelectionScreen': (context) => AddressSelectionScreen(),
          '/UserAccountScreen': (context) => UserAccountScreen(),
          '/HomeScreen': (context) => HomeScreen(),
          '/LoginScreen': (context) => LoginScreen(),
          '/VerifyOTPScreen': (context) => VerifyOTPScreen(),
          '/ListViewPage': (context) => ListViewPage(),
          '/AddFreeFood': (context) => AddFreeFood(),
          '/ForumPage': (context) => ForumPage(),
          '/MessagePage': (context) => MessagePage(),
          '/Register': (context) => Register(),
          '/Login': (context) => LoginPage(),
          '/ValidateOTP': (context) => ValidateOTP(userEmail: 'abc@d.com'),
          '/myList': (context) => MyListings(),
          '/myRequests': (context) => MyRequests(),
          '/SupplierLocationMap': (context) =>
              SupplierLocationMap(selectedLocation: LatLng(0, 0)),
          '/Profile': (context) => UserProfile(),
          '/PublicProfile': (context) => PublicProfile(userId: 1),
          '/AdsPage': (context) => AdvertisePage(),
          '/ChatPage': (context) => ChatPage(),
        });
  }

  Future<Widget?> getFirstPage() async {
    if (await UserStorageService.isUserLoggedIn()) {
      return RootScreen();
    } else {
      return null;
    }
  }
}
