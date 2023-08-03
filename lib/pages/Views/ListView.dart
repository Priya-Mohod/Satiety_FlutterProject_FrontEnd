import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Constatnts/bottomNavigationBar.dart';
import 'package:satietyfrontend/pages/ViewModels/FoodListViewModel.dart';
import 'package:satietyfrontend/pages/Views/FoodDetails.dart';
import 'package:satietyfrontend/pages/Views/FreeFood.dart';
import 'package:satietyfrontend/pages/getData.dart';
import 'package:satietyfrontend/pages/Constatnts/SideDrawer.dart';
import 'package:satietyfrontend/pages/Constatnts/bottomdrawer.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

String getdata = '';
Map mapData = {};
List allData = [];

class _ListViewPageState extends State<ListViewPage> {
  @override
  void initState() {
    super.initState();
    var result =
        Provider.of<FoodListViewModel>(context, listen: false).fetchFoodData();
    if (result == false) {
      // show snackbar
      var showSnackBar = ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to fetch data'),
        ),
      );
    }
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
          'Food List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        //centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
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
            Navigator.pushReplacementNamed(context, '/BookmarksPage');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/MessegePage');
          }
        },
      ),
      endDrawer: SideDrawer(
        foodItem: foodList[_selectedIndex],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
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
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<FoodListViewModel>(
              builder: (context, foodListViewModel, child) {
                final foodList = foodListViewModel.foodList;

                return ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    final foodItem = foodList[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the value as needed
                          side: const BorderSide(
                              color: Color.fromARGB(255, 128, 172, 177),
                              width: 1.0), // Add border color and width
                        ),
                        elevation: 5,
                        child: Container(
                          height: 130,
                          child: ListTile(
                            leading: Container(
                              child: Image.network(
                                foodItem.foodSignedUrl,
                                height: 50,
                                width: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'images/a.png',
                                    height: 50,
                                    width: 50,
                                  );
                                },
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
                                      Icon(Icons.account_circle, size: 25),
                                      SizedBox(width: 10),
                                      Text(foodItem.addedByUserName,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(width: 10),
                                      Icon(Icons.star,
                                          color:
                                              Color.fromARGB(255, 221, 161, 32),
                                          size: 25),
                                      SizedBox(width: 5),
                                      Text('4.5',
                                          style: TextStyle(fontSize: 18)),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.location_on_outlined, size: 30),
                                Text('1.5 km',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
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

/*
      // body: ListView.builder(
      //   itemBuilder: (context, index) {
      //     return Container(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           SizedBox(height: 10),
      //           Container(
      //             height: 150,
      //             width: 400,
      //             decoration: BoxDecoration(
      //               border: Border.all(
      //                 color: Colors.black,
      //                 width: 2,
      //               ),
      //               borderRadius: BorderRadius.circular(20),
      //               color: Colors.cyan[100],
      //             ),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Image.network(
      //                   allData[index]['foodImageUri'],
      //                   height: 100,
      //                   width: 100,
      //                 ),
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.end,
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     Container(
      //                       alignment: Alignment.centerLeft,
      //                       color: Colors.cyanAccent[400],
      //                       height: 35,
      //                       width: 280,
      //                       child: Text(
      //                         allData[index]['freeFoodName'].toString(),
      //                         textDirection: TextDirection.rtl,
      //                         style: const TextStyle(
      //                           fontSize: 30,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ),
      //                     Container(
      //                       margin: const EdgeInsets.only(left: 10),
      //                       color: Color.fromARGB(255, 104, 213, 219),
      //                       height: 100,
      //                       width: 280,
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                         children: [
      //                           Text(
      //                             allData[index]['freeFoodDescription']
      //                                 .toString(),
      //                             style: const TextStyle(
      //                               fontSize: 20,
      //                               fontWeight: FontWeight.bold,
      //                             ),
      //                           ),
      //                           Text(
      //                             'Quantity: ${allData[index]['freeFoodQuantity'].toString()}',
      //                             style: const TextStyle(
      //                               fontSize: 20,
      //                               fontWeight: FontWeight.bold,
      //                             ),
      //                           ),
      //                           Text(
      //                             'Address: ${allData[index]['freeFoodAddress'].toString()}',
      //                             style: const TextStyle(
      //                               fontSize: 20,
      //                               fontWeight: FontWeight.bold,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     );
      //   },
      //   itemCount: allData.length,
      // ),
    );
  }
}


              Padding(
                  padding: EdgeInsets.all(4),
                  child: Image.asset('images/a.png'),
                ),
              Text(allData[index]['freeFoodName'].toString()),
              Text(allData[index]['freeFoodDescription'].toString()),
              Text(allData[index]['freeFoodQuantity'].toString()),
              Text(allData[index]['freeFoodAddress'].toString()),
Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/b.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        //color: Colors.yellow,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  elevation: 10,
                  minimumSize: const Size(250, 60),
                ),
                onPressed: () {
                  // data.getData;
                },
                child: const Text(
                  'Show List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'calibri',
                  ),
                ),
              ),
              Center(
                child: Container(
                    height: 500,
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Center(child: Text(mapData[].toString()))),
              ),
            ],
          ),
        ),
      ),

      ///////////////


      ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 150,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.cyan[100],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Food Name: ${allData[index]['freeFoodName'].toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Food Description: ${allData[index]['freeFoodDescription'].toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Food Quantity: ${allData[index]['freeFoodQuantity'].toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Food Address: ${allData[index]['freeFoodAddress'].toString()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: allData.length,
      ),
      */
