import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Services/Utility.dart';
import '../Models/UserModel.dart';
import '../Services/UserStorageService.dart';
import 'package:retry/retry.dart';

import 'SelectedPageProvider.dart';
import 'StringConstants.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  User? currentUser;

  final retryOptions = RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 2),
  );

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    User? localUser = await UserStorageService.getUserFromSharedPreferances();
    if (localUser != null) {
      var response = await AppUtil().getUserUsingEmail(localUser.email);
      setState(() {
        currentUser = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPageProvider =
        Provider.of<SelectedPageProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan[300],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 22, 220, 210),
                  Color.fromARGB(255, 245, 248, 248),
                ],
              ),
            ),
            child: Container(
              height: 100,
              width: 200,
              //color: Colors.black45,
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      currentUser?.imageSignedUrl ?? '',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'images/account.png',
                          height: 60,
                          width: 60,
                        );
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          // Image has finished loading
                          return child;
                        } else {
                          return Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   '',
                      //   style: TextStyle(fontSize: 18),
                      // ),
                      FutureBuilder<String>(
                        future: getCurrentUserName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Container(
                              width: 150,
                              child: Text(
                                snapshot.data ?? '', // Use the fetched data
                                style: TextStyle(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            );
                          }
                        },
                      ),
                      Row(
                        children: const [
                          // todo take actual rating from the database
                          Icon(Icons.star,
                              color: Color.fromARGB(255, 221, 161, 32),
                              size: 25),
                          SizedBox(width: 5),
                          Text(
                            '4.5',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.home),
              title: Text(StringConstants.Dashboard_title),
              onTap: () {
                Navigator.pop(context);
                //Navigator.pushReplacementNamed(context, '/ListViewPage');
                if (selectedPageProvider.selectedPage !=
                    StringConstants.Dashboard) {
                  selectedPageProvider
                      .setSelectedPage(StringConstants.Dashboard);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    StringConstants.Dashboard,
                    (route) => false,
                  );
                }
              }),
          ListTile(
            leading: Icon(Icons.forum),
            title: Text(StringConstants.Forum_title),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushReplacementNamed(context, '/ForumPage');
              if (selectedPageProvider.selectedPage !=
                  StringConstants.Forum_title) {
                selectedPageProvider
                    .setSelectedPage(StringConstants.Forum_title);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringConstants.Forum,
                  (route) => false,
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(StringConstants.MyListings_title),
            onTap: () {
              Navigator.pop(context);
              if (selectedPageProvider.selectedPage !=
                  StringConstants.MyListings_title) {
                selectedPageProvider
                    .setSelectedPage(StringConstants.MyListings_title);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringConstants.MyListings,
                  (route) => false,
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.remove_from_queue_outlined),
            title: Text(StringConstants.MyRequests_title),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushReplacementNamed(context, '/myRequests');
              if (selectedPageProvider.selectedPage !=
                  StringConstants.MyRequests_title) {
                selectedPageProvider
                    .setSelectedPage(StringConstants.MyRequests_title);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringConstants.MyRequests,
                  (route) => false,
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.emoji_emotions_sharp),
            title: Text(StringConstants.Profile_title),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushReplacementNamed(context, '/Profile');
              if (selectedPageProvider.selectedPage !=
                  StringConstants.Profile_title) {
                selectedPageProvider
                    .setSelectedPage(StringConstants.Profile_title);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringConstants.Profile,
                  (route) => false,
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text(StringConstants.Notifications_title),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushReplacementNamed(context, '/ForumPage');
              if (selectedPageProvider.selectedPage !=
                  StringConstants.Notifications_title) {
                selectedPageProvider
                    .setSelectedPage(StringConstants.Notifications_title);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringConstants.Notifications,
                  (route) => false,
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_sharp),
            title: Text(StringConstants.UsersNearMe_title),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushReplacementNamed(context, '/ForumPage');
              if (selectedPageProvider.selectedPage !=
                  StringConstants.UsersNearMe_title) {
                selectedPageProvider
                    .setSelectedPage(StringConstants.UsersNearMe_title);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringConstants.UsersNearMe,
                  (route) => false,
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text(StringConstants.HelpCenter_title),
            onTap: () {
              Navigator.pop(context);
              //Navigator.pushReplacementNamed(context, '/ForumPage');
              if (selectedPageProvider.selectedPage !=
                  StringConstants.HelpCenter_title) {
                selectedPageProvider
                    .setSelectedPage(StringConstants.HelpCenter_title);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringConstants.HelpCenter,
                  (route) => false,
                );
              }
            },
          ),
          DrawerHeader(
            padding: EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              color: Colors.cyan[300],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 22, 220, 210),
                  Color.fromARGB(255, 245, 248, 248),
                ],
              ),
            ),
            child: ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.black, size: 30),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Close the drawer
                Navigator.pop(context);

                // Show the logout confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout Confirmation'),
                      content: Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            UserStorageService
                                .removeUserFromSharedPreferances();
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.pushReplacementNamed(context, '/Login');
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getCurrentUserName() async {
    // Get the user data from the shared preferences
    User? currentUser = await UserStorageService.getUserFromSharedPreferances();
    if (currentUser != null) {
      return currentUser.firstName;
    } else {
      return '';
    }
  }

  Future<String> getCurrentUserImage() async {
    // Get the user data from the shared preferences
    User? currentUser = await UserStorageService.getUserFromSharedPreferances();
    return currentUser?.imageSignedUrl ?? '';
    // if (currentUser != null) {
    //   return currentUser.firstName;
    // } else {
    //   return '';
    // }
  }
}
