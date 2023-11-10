import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:satietyfrontend/pages/Screens/AddressSelectionScreen.dart';
import 'package:satietyfrontend/pages/Screens/UserAccountScreen.dart';
import 'package:satietyfrontend/pages/Views/SupplierLocationMap.dart';

class CustomHeader extends StatefulWidget {
  @override
  _CustomHeaderState createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          IconButton(
            icon: Icon(CupertinoIcons.location_fill, color: Colors.orange),
            onPressed: () {
              // Add functionality for location icon here
              _showAddresScreen();
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("Address tapped!");
                _showAddresScreen();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "Address 1 asfkjahdkjhakjdhkahsd",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(CupertinoIcons.arrow_down_square)
                    ],
                  ),
                  Text(
                    '123, Main Street, City, State',
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(CupertinoIcons.person_crop_circle_fill),
            onPressed: () {
              // Add functionality for user account icon here
              _showAccountScreen();
            },
          ),
        ],
      ),
    );
  }

  void _showAccountScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserAccountScreen()));
  }

  void _showAddresScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddressSelectionScreen()));
  }
}