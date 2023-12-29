import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Constants/FilterConstants.dart';
import 'package:satietyfrontend/pages/Constants/LoadingIndicator.dart';
import 'package:satietyfrontend/pages/Constants/SelectedPageProvider.dart';
import 'package:satietyfrontend/pages/Constants/StringConstants.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/Services/Utility.dart';
import 'package:satietyfrontend/pages/ViewModels/FoodListViewModel.dart';
import 'package:satietyfrontend/pages/Views/Cards/HomeScreenCard.dart';
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
  var searchItemKeyword = '';
  User? currentUser;

  @override
  void initState() {
    super.initState();
    initializedData({"": ""});
    getCurrentUser();
  }

  Future<void> _refresh() async {
    // Simulate an async operation, e.g., fetching new data
    await Future.delayed(Duration(seconds: 1));

    //setState(() {
    // Update your data source here
    initializedData({"": ""});
    //});
  }

  Future initializedData(Map<String, String> filterDict) async {
    var result = await Provider.of<FoodListViewModel>(context, listen: false)
        .fetchFoodData(filterDict);
    print(result);
    if (result == false) {
      // ignore: use_build_context_synchronously
      SnackbarHelper.showSnackBar(context, StringConstants.server_error);
    }
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
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Padding(
              // margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
              padding: const EdgeInsets.all(10.0),
              child: CustomSearchBar(
                  searchText: 'Search',
                  onSearch: (value) {
                    setState(() {
                      searchItemKeyword = value;
                    });
                  }),
            ),
          ),

          //  SearchBarView(onSearchTextChanged: (String text) {}, height: 60),
          HorizontalFilterBar(
            options: [
              FilterConstants.foodAmount_free.value,
              FilterConstants.foodAmount_chargeable.value,
              FilterConstants.foodType_veg.value,
              FilterConstants.foodType_non_veg.value,
              FilterConstants.foodAvailability_available.value,
              FilterConstants.foodAvailability_just_gone.value,
              FilterConstants.filter_distance.value,
            ],
            onOptionSelected: (selectedOption) {
              // Handle the selected option
              print('Selected option: $selectedOption');
            },
            height: 50,
            onApplyFilter: (Set<String> filteredApplied,
                DistanceFilter distanceFilterApplied) {
              // Get the filtered data in dictionary using filtered key values
              //
              print(filteredApplied);
              print(distanceFilterApplied);
              // Get the data parse into dictionary
              Map<String, String> dict =
                  _getFilterDictionary(filteredApplied, distanceFilterApplied);
              initializedData(dict);
              setState(() {});
            },
          ),
          // Add other widgets for the body of the HomeScreen here
          Expanded(
            child: Consumer<FoodListViewModel>(
              builder: (context, foodListViewModel, child) {
                List<FoodItem> foodList = foodListViewModel.foodList;
                if (searchItemKeyword.isNotEmpty &&
                    searchItemKeyword.length > 0) {
                  // Apply search on food list
                  foodList = foodList
                      .where((foodItem) => foodItem.foodName
                          .toLowerCase()
                          .contains(searchItemKeyword.toLowerCase()))
                      .toList();
                }
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

  Map<String, String> _getFilterDictionary(
      Set<String> filterApplied, DistanceFilter distanceFilterApplied) {
    Map<String, String> filteredDict = {"": ""};
    // -- check if food type available,
    // check if filteredApplied contains foodType all
    // if (filterApplied.contains(FilterConstants.foodType_all.value)) {
    // } else {
    // check if set contains Veg or Non-veg
    if (filterApplied.contains(FilterConstants.foodType_veg.value) &&
        filterApplied.contains(FilterConstants.foodType_non_veg.value)) {
      filteredDict["foodTypeFilter"] = "";
    } else if (filterApplied.contains(FilterConstants.foodType_veg.value)) {
      // add key in dict
      filteredDict["foodTypeFilter"] = FilterConstants.foodType_veg.value;
    } else if (filterApplied.contains(FilterConstants.foodType_non_veg.value)) {
      filteredDict["foodTypeFilter"] = FilterConstants.foodType_non_veg.value;
    }
    //}

    // check if filteredApplied contains foodAmount all
    // if (filterApplied.contains(FilterConstants.foodAmount_all.value)) {
    // } else {
    if (filterApplied.contains(FilterConstants.foodAmount_free.value) &&
        filterApplied.contains(FilterConstants.foodAmount_chargeable.value)) {
      filteredDict["foodAmountFilter"] = "";
    } else if (filterApplied.contains(FilterConstants.foodAmount_free.value)) {
      // add key in dict
      filteredDict["foodAmountFilter"] = FilterConstants.foodAmount_free.value;
    } else if (filterApplied
        .contains(FilterConstants.foodAmount_chargeable.value)) {
      filteredDict["foodAmountFilter"] =
          FilterConstants.foodAmount_chargeable.value;
    }
    //}

    // check if filteredApplied contains foodAvailability all
    // if (filterApplied.contains(FilterConstants.foodAvailability_all.value)) {
    // } else {
    if (filterApplied
            .contains(FilterConstants.foodAvailability_available.value) &&
        filterApplied
            .contains(FilterConstants.foodAvailability_just_gone.value)) {
      filteredDict["availabilityFilter"] = "";
    } else if (filterApplied
        .contains(FilterConstants.foodAvailability_available.value)) {
      // add key in dict
      filteredDict["availabilityFilter"] =
          FilterConstants.foodAvailability_available.value;
    } else if (filterApplied
        .contains(FilterConstants.foodAvailability_just_gone.value)) {
      filteredDict["availabilityFilter"] =
          FilterConstants.foodAvailability_just_gone.value;
    }
    //}

    if (filterApplied.contains(FilterConstants.filter_distance.value)) {
      // if distance filter applied then get the value of distance
      String distanceFilterValue =
          FilterConstants.getDistanceFilterValue(distanceFilterApplied);
      filteredDict["distanceFilter"] = distanceFilterValue;
    }

    return filteredDict;
  }
}
