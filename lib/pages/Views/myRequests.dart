import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Constants/SideDrawer.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/Models/FoodRequestsModel.dart';
import 'package:satietyfrontend/pages/ViewModels/requestProvider.dart';
import 'package:satietyfrontend/pages/Views/ClickableLabel.dart';

import '../Constants/Drawers.dart';
import '../Constants/StringConstants.dart';
import '../Constants/bottomNavigationBar.dart';
import '../ViewModels/MyRequestsViewModel.dart';
import 'SnackbarHelper.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  final MyRequestsViewModel viewModel = MyRequestsViewModel();
  late Future<List<FoodRequest>> dataListFuture;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    dataListFuture = viewModel.fetchRequests();
    print(dataListFuture);
  }

  void refreshData() {
    setState(() {
      fetchRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants.my_requests_screen_title),
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
      body: FutureBuilder<List<FoodRequest>>(
        future: dataListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading data', textScaleFactor: 1.5));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(StringConstants.my_requests_no_requests_available,
                    textScaleFactor: 1.5));
          } else {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                  child: Text(StringConstants.my_requests_screen_no_listings));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  FoodRequest request = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 4, // Optional: Add a shadow effect
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding:
                              EdgeInsets.all(16), // Adjust padding as needed
                          title: Text(
                            request.foodItem!.foodName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Requested on ${getFormattedDateTime(request.requestedAt!)}',
                              ),
                              SizedBox(height: 8),
                              Text(
                                request.acceptedFlag == 'Y'
                                    ? 'Accepted'
                                    : 'Pending',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: request.acceptedFlag == 'Y'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                    ),
                                    onPressed: () async {
                                      // Handle cancel request
                                      bool result =
                                          await viewModel.onRequestCancelClick(
                                              request.requestId);
                                      if (result) {
                                        // Show alert dialog
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Cancel'),
                                            content: Text(StringConstants
                                                .my_requests_request_cancelled),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  refreshData();
                                                  Navigator.pop(context);
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        // Show SnackbarHelper
                                        SnackbarHelper.showSnackBar(
                                          context,
                                          StringConstants
                                              .my_listings_error_cancel_request,
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Cancel Request',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  ClickableLabel(
                                    label: 'Connect Supplier',
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Site under development'),
                                          content: Text(
                                              'On this selection, you can connect with the supplier soon'),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    isEnabled: request.acceptedFlag ==
                                        'Y', // Pass the isEnabled condition
                                  ),
                                ],
                              ),
                            ],
                          ),
                          leading: Container(
                            width: 100,
                            height: 100,
                            child: ClipPath(
                              // clipper:
                              //     MyCustomShapeClipper(), // Define your custom clipper
                              child: Image.network(
                                request.foodItem!.foodSignedUrl ??
                                    'images/a.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      endDrawer: SideDrawer(),
    );
  }

  String getFormattedDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat.MMMMd().format(dateTime); // Format date
    String formattedTime = DateFormat.jm().format(dateTime); // Format time
    return '$formattedDate at $formattedTime';
  }
}

class MyCustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Define the custom shape path here
    final path = Path();

    // Add path instructions to define your custom shape
    // For example, you can create a rounded rectangle
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
        Radius.circular(20), // Adjust the radius as needed
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // Return true if the old clipper should be replaced with a new one
    return false; // You can change this based on your requirements
  }
}
