import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Constants/Drawers.dart';
import 'package:satietyfrontend/pages/Constants/LoadingIndicator.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/Messagepage.dart';
import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/Screens/HomeScreen.dart';
import 'package:satietyfrontend/pages/Screens/login_phone_otp_screen.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/Views/CustomBottomBar.dart';
import 'package:satietyfrontend/pages/Views/CustomHeader.dart';
import 'package:satietyfrontend/pages/Views/add_food.dart';
import 'package:satietyfrontend/pages/Views/ListView.dart';
import 'package:satietyfrontend/pages/Views/MyListings.dart';
import 'package:satietyfrontend/pages/Views/chatPage.dart';
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
    //  LoadingIndicator.instance.hide();
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // _checkAndShowLocationSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            if (selectedPage == Pages.Home) LocationIcon(),
            if (selectedPage == Pages.Home) Expanded(child: AddressInfo()),
            if (selectedPage != Pages.Home)
              Expanded(
                child: PageHeader(
                  pageHeading: selectedPage.name,
                ),
              ),
            AccountIcon(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: selectedPage.index,
        onTap: (index) async {
          bool isUserLoggedIn = await UserStorageService.isUserLoggedIn();
          if (index == Pages.Home.index) {
            // Set selected page as Home
            //selectedPageProvider.setSelectedPage(StringConstants.Home);
            //Navigator.pushReplacementNamed(context, StringConstants.Home);
            setState(() {
              selectedPage = Pages.Home;
            });
          } else if (isUserLoggedIn) {
            if (index == Pages.MyListings.index) {
              // Set selected page as MyListings
              // selectedPageProvider.setSelectedPage(StringConstants.MyListings);
              // Navigator.pushReplacementNamed(context, StringConstants.MyListings);

              setState(() {
                selectedPage = Pages.MyListings;
              });
            } else if (index == Pages.Add.index) {
              //BottomDrawer.showBottomDrawer(context);
              setState(() {
                selectedPage = Pages.Add;
              });
            } else if (index == Pages.MyRequests.index) {
              // selectedPageProvider.setSelectedPage(StringConstants.AdsPage);
              // Navigator.pushReplacementNamed(context, StringConstants.AdsPage);

              setState(() {
                selectedPage = Pages.MyRequests;
              });
            } else if (index == Pages.Messages.index) {
              // selectedPageProvider.setSelectedPage(StringConstants.MessagePage);
              // Navigator.pushReplacementNamed(context, StringConstants.MessagePage);
              setState(() {
                selectedPage = Pages.Messages;
              });
            }
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPhoneOTPScreen(
                    showSkipButton: false,
                  ),
                ));
          }
        },
      ),
      body: IndexedStack(
        index: selectedPage.index,
        children: [
          selectedPage.index == Pages.Home.index
              ? HomeScreen()
              : ChatPage(), // Using chat page temporary
          selectedPage.index == Pages.MyListings.index
              ? MyListings()
              : ChatPage(),
          selectedPage.index == Pages.Add.index ? AddFood() : ChatPage(),
          selectedPage.index == Pages.MyRequests.index
              ? MyRequests()
              : ChatPage(),
          selectedPage.index == Pages.Messages.index
              ? MessagePage()
              : ChatPage(),
        ],
      ),
    );
  }
}
