import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import '../Constants/Drawers.dart';
import '../Constants/SideDrawer.dart';
import '../Constants/StringConstants.dart';
import '../Constants/bottomNavigationBar.dart';
import '../Models/FoodItemModel.dart';
import '../Models/FoodRequestsModel.dart';
import '../ViewModels/MyListingsViewModel.dart';

class MyListings extends StatefulWidget {
  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends State<MyListings> {
  final MyListingsViewModel viewModel = MyListingsViewModel();
  late Future<List<MyListingsDTO>> dataListFuture;

  @override
  void initState() {
    super.initState();
    fetchListings();
  }

  Future<void> fetchListings() async {
    dataListFuture = viewModel.fetchListings();
    print(dataListFuture);
  }

  void refreshData() {
    setState(() {
      fetchListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants.my_listings_screen_title),
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
      body: FutureBuilder(
        future: dataListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading data', textScaleFactor: 1.5));
          } else {
            final List<MyListingsDTO>? dataList = snapshot.data;
            if (dataList == null || dataList.isEmpty) {
              return Center(
                  child: Text(StringConstants.my_listings_screen_no_listings));
            } else {
              return ListingScreen(dataList, viewModel, refreshData);
            }
          }
        },
      ),
      endDrawer: const SideDrawer(),
    );
  }
}

class ListingScreen extends StatelessWidget {
  final List<MyListingsDTO>? dataList;
  final MyListingsViewModel _viewModel;
  final VoidCallback refreshCallback;

  ListingScreen(this.dataList, this._viewModel, this.refreshCallback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: dataList!.length,
        itemBuilder: (context, index) {
          final foodItem = dataList![index].foodItem;
          final requestsList = dataList![index].foodRequestsList;

          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Container(
                    width: 100,
                    height: 100,
                    child: ClipPath(
                      clipper:
                          MyCustomShapeClipper(), // Define your custom clipper
                      child: Image.network(
                        foodItem.foodSignedUrl ?? 'images/a.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(foodItem.foodName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(foodItem.foodDescription),
                      Text(foodItem.foodType),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(StringConstants.my_listings_received_requests),
                ),
                Column(
                  children: requestsList.map<Widget>((request) {
                    return ListTile(
                      onTap: () {
                        // Show Dialog
                        // In Progress, You can connect with user here
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Site under development'),
                            content: Text(
                                'On this selection, you can connect with the consumer soon'),
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
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(request.requestedUserImageUrl ?? ''),
                      ),
                      title: Text(
                        request.requestedUserName ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      // subtitle: Text(
                      //     request.acceptedFlag == 'Y' ? 'Accepted' : 'Pending'),
                      trailing: Container(
                        width: 170,
                        child: buildButtons(context, request),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildButtons(BuildContext context, FoodRequest request) {
    if (request.acceptedFlag == 'Y') {
      return Row(children: [
        Text('Accepted',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () async {
            // Handle Accept button tap
            // TODO : Implement request cancellation
            var result =
                await _viewModel.onRequestDeclineClick(request.requestId);
            if (result) {
              // Show alert dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Cancel'),
                  content: Text('Request cancelled successfully'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        refreshCallback();
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
                  context, StringConstants.my_listings_error_cancel_request);
            }
          },
          child: const Text('Cancel'),
        ),
      ]);
    } else {
      return Row(
        children: [
          ElevatedButton(
            onPressed: () async {
              // Handle Accept button tap
              var result =
                  await _viewModel.onRequestAcceptClick(request.requestId);
              if (result) {
                // Show alert dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Success'),
                    content: Text('Request accepted successfully'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // Refresh the page
                          refreshCallback();
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
                    context, StringConstants.my_listings_error_accept_request);
              }
            },
            child: const Text('Accept'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () async {
              // Handle Decline button tap
              var result =
                  await _viewModel.onRequestDeclineClick(request.requestId);
              if (result) {
                // Show alert dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Success'),
                    content: Text('Request declined successfully'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // Refresh the page
                          refreshCallback();
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
                    context, StringConstants.my_listings_error_decline_request);
              }
            },
            child: Text('Decline'),
          ),
        ],
      );
    }
  }
}

// Define a custom clipper class for the image shape
class MyCustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 10.0;
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - radius, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
