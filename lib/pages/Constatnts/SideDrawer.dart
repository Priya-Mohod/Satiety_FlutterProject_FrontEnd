import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';

class SideDrawer extends StatelessWidget {
  final FoodItem foodItem;
  SideDrawer({required this.foodItem});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan[300],
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'images/a.png',
                    height: 50,
                    width: 50,
                  ),
                  // Image.network(
                  //   foodItem.foodSignedUrl,
                  //   width: 50,
                  //   height: 50,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      foodItem.addedByUserName,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star,
                            color: Color.fromARGB(255, 221, 161, 32), size: 25),
                        SizedBox(width: 5),
                        Text('4.5', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              // Close the drawer and navigate to the home page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ListViewPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.forum),
            title: Text('Forum'),
            onTap: () {
              // Close the drawer and navigate to the forum page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ForumPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('My Listings'),
            onTap: () {
              // Close the drawer and navigate to the forum page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ForumPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.remove_from_queue_outlined),
            title: Text('My Requests'),
            onTap: () {
              // Close the drawer and navigate to the forum page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ForumPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Account'),
            onTap: () {
              // Close the drawer and navigate to the forum page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ForumPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.emoji_emotions_sharp),
            title: Text('Profile'),
            onTap: () {
              // Close the drawer and navigate to the forum page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ForumPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text('Notifications'),
            onTap: () {
              // Close the drawer and navigate to the forum page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ForumPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Location'),
            onTap: () {
              // Close the drawer and navigate to the forum page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ForumPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_sharp),
            title: Text('Users near me'),
            onTap: () {
              // Close the drawer and navigate to the forum page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ForumPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help center'),
            onTap: () {
              // Close the drawer and navigate to the forum page
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/ForumPage');
            },
          ),
          // Add more items in the drawer as needed
        ],
      ),
    );
  }
}
