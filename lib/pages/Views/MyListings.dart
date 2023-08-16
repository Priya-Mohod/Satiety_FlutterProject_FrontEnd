import 'package:flutter/material.dart';
import '../Constants/Drawers.dart';
import '../Constants/SideDrawer.dart';
import '../Constants/bottomNavigationBar.dart';
import '../Models/FoodItemModel.dart';
import '../Models/FoodRequestsModel.dart';
import '../ViewModels/MyListingsViewModel.dart';

class MyListings extends StatefulWidget {
  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends State<MyListings> {
  final MyListingsViewModel _viewModel = MyListingsViewModel();
  Map<FoodItem, List<FoodRequest>>? _dataMap = {};

  @override
  void initState() {
    super.initState();
    _viewModel.fetchListings();
    fetchListings();
  }

  Future<void> fetchListings() async {
    _dataMap = await _viewModel.fetchListings();
    print(_dataMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Listings')),
      body: FutureBuilder(
        future: _viewModel.fetchListings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            return ListingScreen(_dataMap!);
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
}

class ListingScreen extends StatelessWidget {
  final Map<FoodItem, List<FoodRequest>> dataMap;

  ListingScreen(this.dataMap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: dataMap.length,
        itemBuilder: (context, index) {
          final foodItem = dataMap.keys.elementAt(index);
          final requestsList = dataMap[foodItem];

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
                  child: Text('Requests:'),
                ),
                Column(
                  children: requestsList!.map<Widget>((request) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(request.requestedUserImageUrl),
                      ),
                      title: Text(request.requestedUserName),
                      // subtitle: Text(
                      //     request.acceptedFlag == 'Y' ? 'Accepted' : 'Pending'),
                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Ensure buttons are compact
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle Accept button tap
                            },
                            child: Text('Accept'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Handle Decline button tap
                            },
                            child: Text('Decline'),
                          ),
                        ],
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
