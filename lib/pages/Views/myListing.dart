import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:satietyfrontend/pages/Constants/SideDrawer.dart';
import 'package:satietyfrontend/pages/Messegepage.dart';
import 'package:satietyfrontend/pages/allergyPage.dart';

class MyFoodListing extends StatefulWidget {
  const MyFoodListing({super.key});

  @override
  State<MyFoodListing> createState() => _MyFoodListingState();
}

class FoodItem {
  final String id;
  final String foodName;
  final String description;
  final bool isAvailable;
  final List<Request> requests;

  FoodItem({
    required this.id,
    required this.foodName,
    required this.description,
    required this.isAvailable,
    required this.requests,
  });
}

class Request {
  final String id;
  final String userId;
  final String message;

  Request({required this.id, required this.userId, required this.message});
}

class _MyFoodListingState extends State<MyFoodListing> {
  List<FoodItem> foodItems = [
    FoodItem(
      id: '1',
      foodName: 'Pizza',
      description: 'Delicious pizza with extra cheese',
      isAvailable: true,
      requests: [
        Request(id: '1', userId: 'Tush', message: 'I want to order a pizza'),
        Request(id: '2', userId: 'Priya', message: 'Can I have a pizza?'),
        Request(id: '3', userId: 'Bhopu', message: 'is pizza still available?'),
      ],
    ),
    FoodItem(
      id: '2',
      foodName: 'Burger',
      description: 'Juicy burger with veggies',
      isAvailable: false,
      requests: [
        Request(
            id: '3', userId: 'user3', message: 'Please make a burger for me'),
      ],
    ),
    // Add more food items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Listings'),
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
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final foodItem = foodItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(foodItem.foodName),
                    subtitle: Text(foodItem.description),
                    trailing: foodItem.isAvailable
                        ? Text('Available',
                            style: TextStyle(color: Colors.green))
                        : Text('Gone', style: TextStyle(color: Colors.red)),
                  ),
                  Divider(),
                  Text('Requests:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: foodItem.requests.length,
                    itemBuilder: (context, requestIndex) {
                      final request = foodItem.requests[requestIndex];
                      return ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('User ${request.userId}'),
                        subtitle: Text(request.message),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle accepting the request
                                // Update the request status in the database accordingly
                                // Send notification to the user who made the request
                              },
                              child: Text('Accept'),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Handle declining the request
                                // Update the request status in the database accordingly
                                // Optionally, notify the user who made the request
                              },
                              child: Text('Decline'),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessegePage(),
                              ));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
