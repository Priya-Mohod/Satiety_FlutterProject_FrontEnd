import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Constants/SideDrawer.dart';
import 'package:satietyfrontend/pages/Messegepage.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/Models/FoodRequestsModel.dart';
import 'package:satietyfrontend/pages/ViewModels/requestProvider.dart';

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
      appBar: AppBar(title: Text(StringConstants.my_requests_screen_title)),
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
                    elevation: 4, // Optional: Add a shadow effect
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image
                          Image.network(
                            request.foodItem!.foodSignedUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.foodItem!.foodName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                    'Requested on ${getFormattedDateTime(request.requestedAt!)}'),
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
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          // Cancel Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                            ),
                            onPressed: () async {
                              // Handle cancel request
                              bool result = await viewModel
                                  .onRequestCancelClick(request.requestId);
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
                                        .my_listings_error_cancel_request);
                              }
                            },
                            child: Text(
                              'Cancel Request',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/ListViewPage');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/ForumPage');
          } else if (index == 2) {
            BottomDrawer.showBottomDrawer(context);
          } else if (index == 3) {
            Navigator.pushReplacementNamed(
                context, '/ForumPage'); // TODO: Change this to Ads Page
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/MessegePage');
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
