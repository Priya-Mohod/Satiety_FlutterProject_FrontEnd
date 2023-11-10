import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/Messagepage.dart';
import 'package:satietyfrontend/pages/Screens/HomeScreen.dart';
import 'package:satietyfrontend/pages/Views/CustomBottomBar.dart';
import 'package:satietyfrontend/pages/Views/CustomHeader.dart';
import 'package:satietyfrontend/pages/Views/MyListings.dart';
import 'package:satietyfrontend/pages/Views/myRequests.dart';
import 'package:satietyfrontend/pages/Views/sample.dart';
import 'package:permission_handler/permission_handler.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  Pages selectedPage = Pages.Home;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _checkAndShowLocationSheet();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndShowLocationSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: CustomHeader(),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: selectedPage.index,
        onTap: (index) {
          if (index == Pages.Home.index && selectedPage != Pages.Home) {
            // Set selected page as Home
            //selectedPageProvider.setSelectedPage(StringConstants.Home);
            //Navigator.pushReplacementNamed(context, StringConstants.Home);
            setState(() {
              selectedPage = Pages.Home;
            });
          } else if (index == Pages.MyListings.index &&
              selectedPage != Pages.MyListings) {
            // Set selected page as MyListings
            // selectedPageProvider.setSelectedPage(StringConstants.MyListings);
            // Navigator.pushReplacementNamed(context, StringConstants.MyListings);
            setState(() {
              selectedPage = Pages.MyListings;
            });
          } else if (index == Pages.Add.index) {
            // BottomDrawer.showBottomDrawer(context);
          } else if (index == Pages.MyRequests.index &&
              selectedPage != Pages.MyRequests) {
            // selectedPageProvider.setSelectedPage(StringConstants.AdsPage);
            // Navigator.pushReplacementNamed(context, StringConstants.AdsPage);
            setState(() {
              selectedPage = Pages.MyRequests;
            });
          } else if (index == Pages.MyRequests.index &&
              selectedPage != Pages.Messages) {
            // selectedPageProvider.setSelectedPage(StringConstants.MessagePage);
            // Navigator.pushReplacementNamed(context, StringConstants.MessagePage);
            setState(() {
              selectedPage = Pages.Messages;
            });
          }
        },
      ),
      body: IndexedStack(
        index: selectedPage.index,
        children: [
          HomeScreen(),
          MyListings(),
          FoodListPage(),
          MyRequests(),
          MessagePage(),
        ],
      ),
    );
  }

  void _checkAndShowLocationSheet() async {
    Position? currentPosition;
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    var locationStatus = await Permission.location.status;
    print("locationStatus");
    print(locationStatus);
    // if (locationStatus == PermissionStatus.denied) {
    //   // You can show a dialog or bottom sheet to explain why you need the location
    //   // and ask the user for permission.
    //   await Permission.location.request();
    // }
    // if (isLocationEnabled) {
    //   currentPosition = await Geolocator.getCurrentPosition();
    // }
    if (locationStatus.isGranted == false) {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (locationStatus == PermissionStatus.denied)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Location is disabled!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Please enable device location to continue.',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Open device settings to enable location
                            openAppSettings();
                          },
                          child: Text('Enable Location'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }
}