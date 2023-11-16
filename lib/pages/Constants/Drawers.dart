import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/ViewModels/FoodListViewModel.dart';

// class BottomDrawer extends StatefulWidget {
//   const BottomDrawer({super.key});

//   @override
//   _BottomDrawerState createState() => _BottomDrawerState();
// }

// class _BottomDrawerState extends State<BottomDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class BottomDrawer {
  static void showBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400, // Set a fixed height for the bottom drawer
          decoration: BoxDecoration(
            color: Colors.cyan[50],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 30),
                  ListTile(
                    leading: Icon(
                      Icons.fastfood_rounded,
                      color: Color.fromARGB(255, 168, 58, 128),
                      size: 35,
                    ),
                    title: Text(
                      'Add Food',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Text(
                      'Give away food for free or chargable, and help the community!',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      // Close the drawer and navigate to the forum page
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/AddFreeFood');
                    },
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 1,
                  ),
                  SizedBox(height: 30),
                  ListTile(
                    leading: Icon(
                      Icons.forum_rounded,
                      color: Color.fromARGB(255, 50, 1, 58),
                      size: 35,
                    ),
                    title: Text(
                      'Forum',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Text(
                      'Share your thoughts and ideas with the community!',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      // Close the drawer and navigate to the forum page
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/ForumPage');
                    },
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 1,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  const Icon(
                    Icons.support_agent_rounded,
                    color: Colors.redAccent,
                    size: 35,
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForumPage(),
                          ));
                    },
                    child: const Text('Help! What can I add?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 201, 54, 35),
                          fontSize: 25,
                          fontFamily: 'times new roman',
                        )),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<String?> showFilterDrawer(
      BuildContext context,
      Set<String> selectedFilter,
      Function(Set<String>) onFilterSelected) async {
    final ScrollController _controller = ScrollController();
    bool _showScrollbar = false;

    var distanceSelected = '';
    return await showModalBottomSheet<String>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
            //height: 800, // Set a fixed height for the bottom drawer
            decoration: BoxDecoration(
              color: Colors.cyan[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(distanceSelected);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: Text('Apply Filter',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'times new roman',
                              )),
                        ))
                  ],
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.black,
                  height: 1,
                  thickness: 1,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Maximum Distance:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Scrollbar(
                          thickness: 10,
                          thumbVisibility: true,
                          controller: _controller,
                          radius: Radius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SingleChildScrollView(
                              controller: _controller,
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                minimumSize: const Size(40, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                distanceSelected = '5';
                                              },
                                              child: Text(
                                                '5 km',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                minimumSize: const Size(40, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                distanceSelected = '7';
                                              },
                                              child: Text(
                                                '7 km',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                minimumSize: const Size(40, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                distanceSelected = '9';
                                              },
                                              child: Text(
                                                '9 km',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                minimumSize: const Size(40, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                distanceSelected = '12';
                                              },
                                              child: Text(
                                                '12 km',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                minimumSize: const Size(40, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                distanceSelected = '15';
                                              },
                                              child: Text(
                                                '15 km',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                minimumSize: const Size(40, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                distanceSelected = '20';
                                              },
                                              child: Text(
                                                '20 km',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                minimumSize: const Size(40, 30),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                distanceSelected = '30';
                                              },
                                              child: Text(
                                                '30 km',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Free or Chargeable:',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(children: [
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: (selectedFilter
                                                                  .contains(
                                                                      "Free") &&
                                                              selectedFilter
                                                                  .contains(
                                                                      "Chargeable"))
                                                          ? Colors.yellow
                                                          : Colors.grey[300],
                                                      minimumSize:
                                                          const Size(40, 30),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      _factoredSelectedFilter(
                                                          selectedFilter,
                                                          "Free,Chargeable",
                                                          onFilterSelected);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.refresh_sharp,
                                                          size: 20,
                                                          color:
                                                              Colors.amber[900],
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text('All',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ],
                                                    )),
                                                SizedBox(width: 10),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          selectedFilter
                                                                  .contains(
                                                                      "Free")
                                                              ? Colors.yellow
                                                              : Colors
                                                                  .grey[300],
                                                      minimumSize:
                                                          const Size(50, 30),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      _factoredSelectedFilter(
                                                          selectedFilter,
                                                          "Free",
                                                          onFilterSelected);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .check_circle_outline,
                                                          size: 20,
                                                          color:
                                                              Colors.green[900],
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text('Free',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ],
                                                    )),
                                                SizedBox(width: 10),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          selectedFilter.contains(
                                                                  "Chargeable")
                                                              ? Colors.yellow
                                                              : Colors
                                                                  .grey[300],
                                                      minimumSize:
                                                          const Size(50, 30),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      _factoredSelectedFilter(
                                                          selectedFilter,
                                                          "Chargeable",
                                                          onFilterSelected);
                                                    },
                                                    child: Row(children: [
                                                      Icon(
                                                        Icons
                                                            .currency_rupee_rounded,
                                                        size: 20,
                                                        color: Colors.red[900],
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('Chargeable',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ])),
                                              ]))
                                        ])),
                              ]),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tiffin Availability',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(children: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: (selectedFilter
                                                                    .contains(
                                                                        "Available") &&
                                                                selectedFilter
                                                                    .contains(
                                                                        "Just Gone"))
                                                            ? Colors.yellow
                                                            : Colors.grey[300],
                                                        minimumSize:
                                                            const Size(40, 30),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _factoredSelectedFilter(
                                                            selectedFilter,
                                                            "Available,Just Gone",
                                                            onFilterSelected);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          // Icon(
                                                          //   Icons.refresh_sharp,
                                                          //   size: 20,
                                                          //   color: Colors.amber[900],
                                                          // ),
                                                          // SizedBox(width: 10),
                                                          Text('All',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ],
                                                      )),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            selectedFilter.contains(
                                                                    "Available")
                                                                ? Colors.yellow
                                                                : Colors
                                                                    .grey[300],
                                                        minimumSize:
                                                            const Size(50, 30),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _factoredSelectedFilter(
                                                            selectedFilter,
                                                            "Available",
                                                            onFilterSelected);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          // Icon(
                                                          //   Icons.check_circle_outline,
                                                          //   size: 20,
                                                          //   color: Colors.green[900],
                                                          // ),
                                                          // SizedBox(width: 10),
                                                          Text('Available',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ],
                                                      )),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            selectedFilter.contains(
                                                                    "Just Gone")
                                                                ? Colors.yellow
                                                                : Colors
                                                                    .grey[300],
                                                        minimumSize:
                                                            const Size(50, 30),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _factoredSelectedFilter(
                                                            selectedFilter,
                                                            "Just Gone",
                                                            onFilterSelected);
                                                      },
                                                      child: Row(children: [
                                                        // Icon(
                                                        //   Icons.currency_rupee_rounded,
                                                        //   size: 20,
                                                        //   color: Colors.red[900],
                                                        // ),
                                                        // SizedBox(width: 10),
                                                        Text('Just Gone',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ])),
                                                ]))
                                          ])),
                                ])),
                        Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Food Type',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(children: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: (selectedFilter
                                                                    .contains(
                                                                        "Veg") &&
                                                                selectedFilter
                                                                    .contains(
                                                                        "Non-Veg"))
                                                            ? Colors.yellow
                                                            : Colors.grey[300],
                                                        minimumSize:
                                                            const Size(40, 30),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _factoredSelectedFilter(
                                                            selectedFilter,
                                                            "Veg,Non-Veg",
                                                            onFilterSelected);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.refresh_sharp,
                                                            size: 20,
                                                            color: Colors
                                                                .amber[900],
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text('All',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ],
                                                      )),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            selectedFilter
                                                                    .contains(
                                                                        "Veg")
                                                                ? Colors.yellow
                                                                : Colors
                                                                    .grey[300],
                                                        minimumSize:
                                                            const Size(50, 30),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _factoredSelectedFilter(
                                                            selectedFilter,
                                                            "Veg",
                                                            onFilterSelected);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .fastfood_rounded,
                                                            size: 20,
                                                            color: Colors
                                                                .green[900],
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text('Veg',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ],
                                                      )),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            selectedFilter
                                                                    .contains(
                                                                        "Non-Veg")
                                                                ? Colors.yellow
                                                                : Colors
                                                                    .grey[300],
                                                        minimumSize:
                                                            const Size(50, 30),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _factoredSelectedFilter(
                                                            selectedFilter,
                                                            "Non-Veg",
                                                            onFilterSelected);
                                                      },
                                                      child: Row(children: [
                                                        Icon(
                                                          Icons
                                                              .fastfood_rounded,
                                                          size: 20,
                                                          color:
                                                              Colors.red[900],
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text('Non-Veg',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ])),
                                                ]))
                                          ])),
                                ])),

                        /*Row(
                          children: [
                            Column(
                              children: [
                                Text('Sort By',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'times new roman',
                                    )),
                                Row(
                                  children: [
                                    SizedBox(height: 20),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Bullet Button Text',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        )*/
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Set<String> _factoredSelectedFilter(Set<String> selectedFilter,
      String checkString, Function(Set<String>) onFilterSelected) {
    // if checkString has "," then check both the string
    List<String> stringParts = checkString.split(',');
    for (int i = 0; i < stringParts.length; i++) {
      if (selectedFilter.contains(stringParts[i])) {
        selectedFilter.remove(stringParts[i]);
      } else {
        selectedFilter.add(stringParts[i]);
      }
    }
    onFilterSelected(selectedFilter);
    return selectedFilter;
  }
}
