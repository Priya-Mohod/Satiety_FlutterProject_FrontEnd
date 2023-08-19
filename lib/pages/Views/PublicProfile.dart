import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:satietyfrontend/pages/Constants/SideDrawer.dart';
import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/ViewModels/PublicProfileViewModel.dart';
import 'package:full_screen_image/full_screen_image.dart';

class PublicProfile extends StatefulWidget {
  // const PublicProfile({super.key});
  final int userId;
  PublicProfile({required this.userId});

  @override
  State<PublicProfile> createState() => _PublicProfileState();
}

class _PublicProfileState extends State<PublicProfile> {
  final PublicProfileViewModel viewModel = PublicProfileViewModel();

  User? user;

  @override
  void initState() {
    super.initState();
    initializeUserData();
  }

  Future<void> initializeUserData() async {
    user = await viewModel.fetchedUserDataById(widget.userId);
    if (user != null) {
      setState(() {
        viewModel.loggedInUser = user;
      });
    }
  }

  Widget build(BuildContext context) {
    if (user == null) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.cyanAccent[400],
        color: Colors.black38,
      ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              text: "${user?.firstName}'s Profile",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.black, size: 30),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ],
        ),
        endDrawer: SideDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  //color: Colors.black26,
                  height: 250,
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.network(
                          user?.imageSignedUrl ?? '',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'images/account.png',
                              height: 100,
                              width: 100,
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
                      SizedBox(width: 20),
                      Container(
                        // color: Colors.black38,
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.firstName ?? '',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 28,
                                  color: Colors.amber[700],
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 28,
                                  color: Colors.amber[700],
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 28,
                                  color: Colors.amber[700],
                                ),
                                Icon(
                                  Icons.star_half_rounded,
                                  size: 28,
                                  color: Colors.amber[700],
                                ),
                                Icon(
                                  Icons.star_outline_rounded,
                                  size: 28,
                                  color: Colors.amber[700],
                                ),
                                SizedBox(width: 10),
                                Text('3.5',
                                    style: TextStyle(
                                      fontSize: 18,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.watch_later_outlined, size: 30),
                    SizedBox(width: 10),
                    Container(
                      //color: Colors.black12,
                      width: 350,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${user?.firstName} joined on August 2023',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Divider(
                  color: Colors.black,
                  height: 1,
                  thickness: 1,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Verified User',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.verified_outlined,
                              size: 30, color: Colors.green),
                          SizedBox(width: 10),
                          Text('Email Verified',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.verified_user,
                              size: 30, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Mobile Verification Pending',
                              style: TextStyle(
                                fontSize: 20,
                              )),
                        ],
                      ),
                      SizedBox(height: 30),
                      Divider(
                        color: Colors.black,
                        height: 1,
                        thickness: 1,
                      ),
                      SizedBox(height: 90),
                      Text('Profile work is inprogress...',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
