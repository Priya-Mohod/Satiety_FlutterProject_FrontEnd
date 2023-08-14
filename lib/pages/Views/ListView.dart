//import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Constatnts/StringConstants.dart';
import 'package:satietyfrontend/pages/ViewModels/FoodListViewModel.dart';
import 'package:satietyfrontend/pages/Views/FoodDetails.dart';
import 'package:satietyfrontend/pages/Views/FreeFood.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import 'package:satietyfrontend/pages/allergyPage.dart';
import 'package:satietyfrontend/pages/getData.dart';
import 'package:satietyfrontend/pages/Constatnts/SideDrawer.dart';
import 'package:satietyfrontend/pages/Constatnts/Drawers.dart';

import '../Constants/bottomNavigationBar.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

String getdata = '';
Map mapData = {};
List allData = [];

class _ListViewPageState extends State<ListViewPage> {
  Future initializedData() async {
    var result = await Provider.of<FoodListViewModel>(context, listen: false)
        .fetchFoodData();
    print(result);
    if (result == false) {
      // show snackbar
      // ignore: use_build_context_synchronously
      SnackbarHelper.showSnackBar(context, StringConstants.server_error);
    }
  }

  @override
  void initState() {
    super.initState();
    initializedData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  //Data data = Data();
  @override
  Widget build(BuildContext context) {
    // Get the foodList from the FoodListViewModel
    final foodList = Provider.of<FoodListViewModel>(context).foodList;
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
          Icon(Icons.location_on_outlined, size: 30),
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
                              backgroundColor: Colors.grey[400],
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              BottomDrawer.showFilterDrawer(context);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.filter_list, size: 30),
                                SizedBox(width: 10),
                                Text('Filter',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outlined, size: 40),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllergyInfo(),
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
          // GestureDetector(onTap: () {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => FoodDetails(foodItem: foodList[0]),
          //       ));
          // }, child: Consumer<FoodListViewModel>(
          //     builder: (context, foodListViewModel, child) {
          //   final foodList = foodListViewModel.foodList;
          //   return ListView.builder(
          //       itemCount: foodList.length,
          //       itemBuilder: (context, index) {
          //         final foodItem = foodList[index];
          //         return Row(children: [
          //           Column(children: [
          //             Container(
          //               color: Colors.grey[300],
          //               height: 100,
          //               width: 100,
          //               child: ClipOval(
          //                 child: Image.network(
          //                   foodList[0].foodSignedUrl,
          //                   height: 100,
          //                   width: 100,
          //                   errorBuilder: (context, error, stackTrace) {
          //                     return Image.asset(
          //                       'images/a.png',
          //                       height: 50,
          //                       width: 50,
          //                     );
          //                   },
          //                 ),
          //               ),
          //             ),
          //           ]),
          //           Column(
          //             children: [
          //               Row(children: [],)
          //             ],
          //           )
          //         ]);
          //       });
          // })),
          Expanded(
            child: Consumer<FoodListViewModel>(
              builder: (context, foodListViewModel, child) {
                final foodList = foodListViewModel.foodList;
                return ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    final foodItem = foodList[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the value as needed
                          side: const BorderSide(
                              color: Color.fromARGB(255, 128, 172, 177),
                              width: 1.0), // Add border color and width
                        ),
                        elevation: 2,
                        child: Container(
                          height: 130,
                          child: ListTile(
                            leading: Container(
                              color: Colors.grey[300],
                              height: 100,
                              width: 100,
                              child: ClipOval(
                                child: Image.network(
                                  foodItem.foodSignedUrl,
                                  height: 100,
                                  width: 100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'images/a.png',
                                      height: 50,
                                      width: 50,
                                    );
                                  },
                                ),
                              ),
                            ),

                            title: Text(foodItem.foodName,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.account_circle, size: 30),
                                      SizedBox(width: 10),
                                      Text(foodItem.addedByUserName,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(width: 10),
                                      Icon(Icons.star,
                                          color:
                                              Color.fromARGB(255, 221, 161, 32),
                                          size: 30),
                                      SizedBox(width: 5),
                                      Text('4.5',
                                          style: TextStyle(fontSize: 20)),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          //'Amount: ${foodItem.foodAmount.toStringAsFixed(1)}'
                                          foodItem.foodAmount == 0.0
                                              ? "Food is Free"
                                              : 'Cost: Rs. ${foodItem.foodAmount}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            //color: Colors.black54,
                                            color: foodItem.foodAmount == 0.0
                                                ? Color.fromARGB(
                                                    255, 40, 125, 43)
                                                : Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(width: 10),
                                      if (foodItem.foodType == 'Veg')
                                        const Icon(Icons.fastfood,
                                            color: Color.fromARGB(
                                                255, 40, 125, 43),
                                            size: 25),
                                      if (foodItem.foodType == 'Non-Veg')
                                        const Icon(Icons.fastfood,
                                            color: Colors.red, size: 25),
                                      if (foodItem.foodType == 'Both')
                                        const Icon(Icons.fastfood,
                                            color: Colors.orange, size: 25),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          size: 25),
                                      Text('1.5 km',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),

                            // Add more widgets for other food details
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FoodDetails(foodItem: foodList[index]),
                                  ));
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
