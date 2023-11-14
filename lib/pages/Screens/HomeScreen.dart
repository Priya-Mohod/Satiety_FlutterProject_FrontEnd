import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Constants/SelectedPageProvider.dart';
import 'package:satietyfrontend/pages/Constants/StringConstants.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/Services/Utility.dart';
import 'package:satietyfrontend/pages/ViewModels/FoodListViewModel.dart';
import 'package:satietyfrontend/pages/Views/Cards/HomeScreenCard.dart';
import 'package:satietyfrontend/pages/Views/CustomBottomBar.dart';
import 'package:satietyfrontend/pages/Views/CustomHeader.dart';
//import 'package:satietyfrontend/pages/Views/FreeFood.dart';
import 'package:satietyfrontend/pages/Views/HorizontalFilterBar.dart';
//import 'package:satietyfrontend/pages/Views/MyListings.dart';
import 'package:satietyfrontend/pages/Views/SearchBarView.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomSearchBar.dart';
//import 'package:satietyfrontend/pages/Views/SupplierLocationMap.dart';
//import 'package:satietyfrontend/pages/Views/myRequests.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController controller = ScrollController();
  var appliedDistanceFilter = '';
  User? currentUser;

  @override
  void initState() {
    super.initState();
    initializedData();
    getCurrentUser();
  }

  Future<void> _refresh() async {
    // Simulate an async operation, e.g., fetching new data
    await Future.delayed(Duration(seconds: 1));

    //setState(() {
    // Update your data source here
    initializedData();
    //});
  }

  Future initializedData() async {
    var result = await Provider.of<FoodListViewModel>(context, listen: false)
        .fetchFoodData(appliedDistanceFilter);
    print(result);
    // if (result == false) {
    //   // ignore: use_build_context_synchronously
    //   SnackbarHelper.showSnackBar(context, StringConstants.server_error);
    // }
  }

  Future<void> getCurrentUser() async {
    // Get the user data from the shared preferences
    //final retryOperation = RetryOperation(options: retryOptions);
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
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Padding(
              // margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
              padding: const EdgeInsets.all(10.0),
              child:
                  CustomSearchBar(searchText: 'Search', onSearch: (value) {}),
            ),
          ),

          //  SearchBarView(onSearchTextChanged: (String text) {}, height: 60),
          HorizontalFilterBar(
            options: [
              'Free',
              'Chargeable',
              'Veg',
              'Non-Veg',
              'Available',
              'Just Gone',
              'Distance'
            ],
            onOptionSelected: (selectedOption) {
              // Handle the selected option
              print('Selected option: $selectedOption');
            },
            height: 50,
          ),
          // Add other widgets for the body of the HomeScreen here
          Expanded(
            child: Consumer<FoodListViewModel>(
              builder: (context, foodListViewModel, child) {
                final foodList = foodListViewModel.foodList;
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: Scrollbar(
                    thickness: 10,
                    thumbVisibility: true,
                    controller: controller,
                    radius: Radius.circular(20),
                    child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      controller: controller,
                      itemCount: foodList.length,
                      itemBuilder: (context, index) {
                        final foodItem = foodList[index];
                        return HomeScreenCard(foodItem: foodItem);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
