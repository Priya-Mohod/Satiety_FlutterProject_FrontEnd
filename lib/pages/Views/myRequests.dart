import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Constants/SideDrawer.dart';
import 'package:satietyfrontend/pages/Messegepage.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/ViewModels/requestProvider.dart';

import '../Constants/Drawers.dart';
import '../Constants/bottomNavigationBar.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Requests'),
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
              Navigator.pushReplacementNamed(context, '/BookmarksPage');
            } else if (index == 4) {
              Navigator.pushReplacementNamed(context, '/MessegePage');
            }
          },
        ),
        body: Consumer<RequestProvider>(
            builder: (context, requestProvider, child) {
          final myRequests = requestProvider.myRequests;

          return ListView.builder(
            itemCount: myRequests.length,
            itemBuilder: (context, index) {
              final request = myRequests[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(request.message),
                    subtitle: Text(request.isAccepted ? 'Accepted' : 'Pending'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Handle accepting or declining the request
                        _handleAcceptRequest(context, request);
                        Navigator.pushReplacementNamed(context, '/myRequests');
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                ),
              );
            },
          );
        }));
  }

  void _handleAcceptRequest(BuildContext context, Request request) {
    // Here, you can implement the logic to handle accepting or declining the request
    // For this example, we'll just toggle the request status between accepted and pending
    final requestProvider =
        Provider.of<RequestProvider>(context, listen: false);

    requestProvider.updateRequestStatus(request, !request.isAccepted);

    if (!request.isAccepted) {
      // Remove the request from myRequests list if it was declined (cancel button pressed)
      requestProvider.removeRequest(request);
      Navigator.pushReplacementNamed(context, '/myRequests');
    }

    // Show a snackbar to inform the user about the status update
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(request.isAccepted ? 'Request Accepted' : 'Request canceled'),
      ),
    );
  }
}
