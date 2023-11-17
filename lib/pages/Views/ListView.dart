import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:retry/retry.dart';
import 'package:satietyfrontend/pages/Constants/ImageLoader/ImageLoader.dart';
import 'package:satietyfrontend/pages/Constants/StringConstants.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/ParsingUtils.dart';
import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/Services/Utility.dart';
import 'package:satietyfrontend/pages/ViewModels/FoodListViewModel.dart';
import 'package:satietyfrontend/pages/Views/ChatPage.dart';
import 'package:satietyfrontend/pages/Views/ChatPageFirebase.dart';
import 'package:satietyfrontend/pages/Views/FoodDetails.dart';
import 'package:satietyfrontend/pages/Views/FreeFood.dart';
import 'package:satietyfrontend/pages/Views/InfoGuide.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import 'package:satietyfrontend/pages/allergyPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Constants/Drawers.dart';
import '../Constants/SelectedPageProvider.dart';
import '../Constants/SideDrawer.dart';
import '../Constants/bottomNavigationBar.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final ScrollController controller = ScrollController();
  var appliedDistanceFilter = '';
  Future initializedData() async {
    var result = await Provider.of<FoodListViewModel>(context, listen: false)
        .fetchFoodData(appliedDistanceFilter);
    print(result);
    if (result == false) {
      // ignore: use_build_context_synchronously
      SnackbarHelper.showSnackBar(context, StringConstants.server_error);
    }
  }

  @override
  void initState() {
    super.initState();
    initializedData();
    getCurrentUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  User? currentUser;
  final retryOptions = RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 2),
  );
  int _selectedIndex = 0;

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

  //Data data = Data();
  @override
  Widget build(BuildContext context) {
    // Get the foodList from the FoodListViewModel
    final selectedPageProvider =
        Provider.of<SelectedPageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringConstants.list_view_screen_title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        //centerTitle: true,
        actions: [
          Icon(Icons.search, size: 30),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0 &&
              selectedPageProvider.selectedPage != StringConstants.Dashboard) {
            selectedPageProvider.setSelectedPage(StringConstants.Dashboard);
            Navigator.pushReplacementNamed(context, StringConstants.Dashboard);
          } else if (index == 1 &&
              selectedPageProvider.selectedPage != StringConstants.Forum) {
            selectedPageProvider.setSelectedPage(StringConstants.Forum);
            Navigator.pushReplacementNamed(context, StringConstants.Forum);
          } else if (index == 2) {
            //   BottomDrawer.showBottomDrawer(context);
          } else if (index == 3 &&
              selectedPageProvider.selectedPage != StringConstants.AdsPage) {
            selectedPageProvider.setSelectedPage(StringConstants.AdsPage);
            Navigator.pushReplacementNamed(context, StringConstants.AdsPage);
          } else if (index == 4 &&
              selectedPageProvider.selectedPage !=
                  StringConstants.MessagePage) {
            selectedPageProvider.setSelectedPage(StringConstants.MessagePage);
            Navigator.pushReplacementNamed(
                context, StringConstants.MessagePage);
          }
        },
      ),
      endDrawer: SideDrawer(),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              minimumSize: const Size(90, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async {
                              /* *** commenting because BottomDrawer converted into stateful widget
                              final selectedFilter = await BottomDrawer()
                                  .showFilterDrawer(
                                      context, {''}, (selectedValue) {});
                              if (selectedFilter != null)
                                appliedDistanceFilter = selectedFilter;
                              _refresh();
                              */
                            },
                            child: Row(
                              children: [
                                Icon(Icons.filter_list, size: 30),
                                SizedBox(width: 7),
                                Text('Filter',
                                    style: TextStyle(
                                      fontSize: 20,
                                      //fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outlined, size: 30),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoGuide(),
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.black,
            height: 1,
            thickness: 1,
          ),
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
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the value as needed
                            side: const BorderSide(
                                color: Color.fromARGB(255, 128, 172, 177),
                                width: 1), // Add border color and width
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FoodDetails(
                                          foodItem: foodList[index]),
                                    ));
                              },
                              child: Container(
                                width: 250,
                                height: 120,
                                // color: Colors.black54,
                                child: Row(
                                  children: [
                                    // ImageLoader(
                                    //   imageUrl: foodItem.foodSignedUrl,
                                    //   imageHeight: 120,
                                    //   imageWidth: 130,
                                    // ),
                                    Container(
                                        height: 120,
                                        width: 130,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                foodItem.foodSignedUrl,
                                                height: 120,
                                                width: 130,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/account.png',
                                                    height: 120,
                                                    width: 130,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    // Image has finished loading
                                                    return child;
                                                  } else {
                                                    return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        )),

                                    SizedBox(width: 15),
                                    Row(
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(foodItem.foodName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              SizedBox(height: 7),
                                              Container(
                                                width: 200,
                                                child: Row(
                                                  children: [
                                                    ClipOval(
                                                        child: Image.network(
                                                      foodItem
                                                          .addedByUserImageUrl,
                                                      height: 40,
                                                      width: 40,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.asset(
                                                          'assets/account.png',
                                                          height: 30,
                                                          width: 30,
                                                        );
                                                      },
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          // Image has finished loading
                                                          return child;
                                                        } else {
                                                          return Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                      },
                                                    )),
                                                    SizedBox(width: 3),
                                                    Container(
                                                      width: 100,
                                                      //color: Colors.black45,
                                                      child: Text(
                                                          foodItem
                                                              .addedByUserName,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[700],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Icon(
                                                      Icons.star_half,
                                                      size: 20,
                                                      color: Colors.orange[800],
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text('3.5',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[800],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 20,
                                                      color: Colors.grey[700]),
                                                  SizedBox(width: 3),
                                                  Text(
                                                      DevelopementConfig().getShowInKM
                                                          ? (foodItem.distanceInKm ??
                                                                  '') +
                                                              ' km'
                                                          : (ParsingUtils
                                                                  .convertKmToMiles(
                                                                      foodItem
                                                                          .distanceInKm)) +
                                                              ' mi',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey[700],
                                                      )),
                                                  SizedBox(width: 10),
                                                  if (foodItem.foodType ==
                                                      'Veg')
                                                    const Icon(Icons.fastfood,
                                                        color: Color.fromARGB(
                                                            255, 40, 125, 43),
                                                        size: 20),
                                                  if (foodItem.foodType ==
                                                      'Non-Veg')
                                                    const Icon(Icons.fastfood,
                                                        color: Colors.red,
                                                        size: 20),
                                                  if (foodItem.foodType ==
                                                      'Both')
                                                    const Icon(Icons.fastfood,
                                                        color: Colors.orange,
                                                        size: 20),
                                                  SizedBox(width: 20),
                                                  if (foodItem.foodAmount ==
                                                      0.0)
                                                    Icon(
                                                      Icons
                                                          .currency_rupee_rounded,
                                                      size: 20,
                                                      color: Colors.green[800],
                                                    ),
                                                  if (foodItem.foodAmount !=
                                                      0.0)
                                                    Icon(
                                                      Icons
                                                          .currency_rupee_rounded,
                                                      size: 20,
                                                      color: Colors.red[900],
                                                    )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
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

  Future<void> _refresh() async {
    // Simulate an async operation, e.g., fetching new data
    await Future.delayed(Duration(seconds: 1));

    //setState(() {
    // Update your data source here
    initializedData();
    //});
  }
}
