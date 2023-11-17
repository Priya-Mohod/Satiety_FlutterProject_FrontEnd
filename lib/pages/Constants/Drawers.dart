import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/ViewModels/FoodListViewModel.dart';

class BottomDrawer extends StatefulWidget {
  Set<String> selectedFilter;
  final Function(Set<String>, DistanceFilter) onFilterSelected;
  DistanceFilter distanceSelected;
  final Function onApplyFilter;

  BottomDrawer({
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.distanceSelected,
    required this.onApplyFilter,
  });

  @override
  _BottomDrawerState createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  final ScrollController _controller = ScrollController();
  final String distanceFilter_five = '5';
  final String distanceFilter_seven = '7';
  final String distanceFilter_nine = '9';
  final String distanceFilter_twelve = '12';
  final String distanceFilter_fifteen = '15';
  final String distanceFilter_twenty = '20';
  final String distanceFilter_thirty = '30';

  final String foodType_all = "All_Veg_Non-Veg";
  final String foodType_veg = "Veg";
  final String foodType_non_veg = "Non-veg";
  final String foodAmount_all = "All_Free_Chargeable";
  final String foodAmount_free = "Free";
  final String foodAmount_chargeable = "Chargeable";
  final String foodAvailability_all = "All_Available_Just Gone";
  final String foodAvailability_available = "Available";
  final String foodAvailability_just_gone = "Just Gone";

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                        child: Row(
                          children: [
                            Text(
                              'Maximum Distance:',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Scrollbar(
                      thickness: 1,
                      thumbVisibility: true,
                      controller: _controller,
                      radius: Radius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SingleChildScrollView(
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                _isDistanceSelected(
                                                        DistanceFilter.five)
                                                    ? Colors.yellow
                                                    : Colors.grey[300],
                                            minimumSize: const Size(40, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            _selectDistanceFilter(
                                                DistanceFilter.five);
                                          },
                                          child: Text(
                                            '$distanceFilter_five km',
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
                                                _isDistanceSelected(
                                                        DistanceFilter.seven)
                                                    ? Colors.yellow
                                                    : Colors.grey[300],
                                            minimumSize: const Size(40, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            _selectDistanceFilter(
                                                DistanceFilter.seven);
                                          },
                                          child: Text(
                                            '$distanceFilter_seven km',
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
                                                _isDistanceSelected(
                                                        DistanceFilter.nine)
                                                    ? Colors.yellow
                                                    : Colors.grey[300],
                                            minimumSize: const Size(40, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            _selectDistanceFilter(
                                                DistanceFilter.nine);
                                          },
                                          child: Text(
                                            '$distanceFilter_nine km',
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
                                                _isDistanceSelected(
                                                        DistanceFilter.twelve)
                                                    ? Colors.yellow
                                                    : Colors.grey[300],
                                            minimumSize: const Size(40, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            _selectDistanceFilter(
                                                DistanceFilter.twelve);
                                          },
                                          child: Text(
                                            '$distanceFilter_twelve km',
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
                                                _isDistanceSelected(
                                                        DistanceFilter.fifteen)
                                                    ? Colors.yellow
                                                    : Colors.grey[300],
                                            minimumSize: const Size(40, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            _selectDistanceFilter(
                                                DistanceFilter.fifteen);
                                          },
                                          child: Text(
                                            '$distanceFilter_fifteen km',
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
                                                _isDistanceSelected(
                                                        DistanceFilter.twenty)
                                                    ? Colors.yellow
                                                    : Colors.grey[300],
                                            minimumSize: const Size(40, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            _selectDistanceFilter(
                                                DistanceFilter.twenty);
                                          },
                                          child: Text(
                                            '$distanceFilter_twenty km',
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
                                                _isDistanceSelected(
                                                        DistanceFilter.thirty)
                                                    ? Colors.yellow
                                                    : Colors.grey[300],
                                            minimumSize: const Size(40, 30),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            _selectDistanceFilter(
                                                DistanceFilter.thirty);
                                          },
                                          child: Text(
                                            '$distanceFilter_thirty km',
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: (widget
                                                              .selectedFilter
                                                              .contains(
                                                                  foodAmount_free) &&
                                                          widget.selectedFilter
                                                              .contains(
                                                                  foodAmount_chargeable))
                                                      ? Colors.yellow
                                                      : Colors.grey[300],
                                                  minimumSize:
                                                      const Size(40, 30),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _factoredSelectedFilter(
                                                      foodAmount_all);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.refresh_sharp,
                                                      size: 20,
                                                      color: Colors.amber[900],
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text('All',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ],
                                                )),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: widget
                                                          .selectedFilter
                                                          .contains(
                                                              foodAmount_free)
                                                      ? Colors.yellow
                                                      : Colors.grey[300],
                                                  minimumSize:
                                                      const Size(50, 30),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _factoredSelectedFilter(
                                                      foodAmount_free);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      size: 20,
                                                      color: Colors.green[900],
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text('Free',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ],
                                                )),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: widget
                                                          .selectedFilter
                                                          .contains(
                                                              foodAmount_chargeable)
                                                      ? Colors.yellow
                                                      : Colors.grey[300],
                                                  minimumSize:
                                                      const Size(50, 30),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _factoredSelectedFilter(
                                                      foodAmount_chargeable);
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(children: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: (widget
                                                                .selectedFilter
                                                                .contains(
                                                                    foodAvailability_available) &&
                                                            widget
                                                                .selectedFilter
                                                                .contains(
                                                                    foodAvailability_just_gone))
                                                        ? Colors.yellow
                                                        : Colors.grey[300],
                                                    minimumSize:
                                                        const Size(40, 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _factoredSelectedFilter(
                                                        foodAvailability_all);
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
                                                                FontWeight.bold,
                                                          )),
                                                    ],
                                                  )),
                                              SizedBox(width: 10),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: widget
                                                            .selectedFilter
                                                            .contains(
                                                                foodAvailability_available)
                                                        ? Colors.yellow
                                                        : Colors.grey[300],
                                                    minimumSize:
                                                        const Size(50, 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _factoredSelectedFilter(
                                                        foodAvailability_available);
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
                                                                FontWeight.bold,
                                                          )),
                                                    ],
                                                  )),
                                              SizedBox(width: 10),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: widget
                                                            .selectedFilter
                                                            .contains(
                                                                foodAvailability_just_gone)
                                                        ? Colors.yellow
                                                        : Colors.grey[300],
                                                    minimumSize:
                                                        const Size(50, 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _factoredSelectedFilter(
                                                        foodAvailability_just_gone);
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
                                                              FontWeight.bold,
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(children: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: (widget
                                                                .selectedFilter
                                                                .contains(
                                                                    foodType_veg) &&
                                                            widget
                                                                .selectedFilter
                                                                .contains(
                                                                    foodType_non_veg))
                                                        ? Colors.yellow
                                                        : Colors.grey[300],
                                                    minimumSize:
                                                        const Size(40, 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _factoredSelectedFilter(
                                                        foodType_all);
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
                                                                FontWeight.bold,
                                                          )),
                                                    ],
                                                  )),
                                              SizedBox(width: 10),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: widget
                                                            .selectedFilter
                                                            .contains(
                                                                foodType_veg)
                                                        ? Colors.yellow
                                                        : Colors.grey[300],
                                                    minimumSize:
                                                        const Size(50, 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _factoredSelectedFilter(
                                                        foodType_veg);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.fastfood_rounded,
                                                        size: 20,
                                                        color:
                                                            Colors.green[900],
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('Veg',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ],
                                                  )),
                                              SizedBox(width: 10),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: widget
                                                            .selectedFilter
                                                            .contains(
                                                                foodType_non_veg)
                                                        ? Colors.yellow
                                                        : Colors.grey[300],
                                                    minimumSize:
                                                        const Size(50, 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _factoredSelectedFilter(
                                                        foodType_non_veg);
                                                  },
                                                  child: Row(children: [
                                                    Icon(
                                                      Icons.fastfood_rounded,
                                                      size: 20,
                                                      color: Colors.red[900],
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text('Non-Veg',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ])),
                                            ]))
                                      ])),
                            ])),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      widget.onApplyFilter();
                      Navigator.of(context).pop(widget.distanceSelected);
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
                    )),
              ],
            ),
            SizedBox(height: 20),
          ],
        ));
  }

  void _selectDistanceFilter(DistanceFilter distanceSelected) {
    if (widget.distanceSelected == distanceSelected) {
      widget.distanceSelected = DistanceFilter.none;
      widget.selectedFilter.remove("Distance");
    } else {
      widget.distanceSelected = distanceSelected;
      widget.selectedFilter.add("Distance");
    }

    reloadScreen_notifyParentAboutSelection();
  }

  bool _isDistanceSelected(DistanceFilter distanceSelected) {
    if (widget.distanceSelected == distanceSelected) {
      return true;
    } else {
      return false;
    }
  }

  void _factoredSelectedFilter(String checkString) {
    // if checkString has "," then check both the string
    // if key is "All_Free_Chargeable",
    // check if key exists, remove the key and its options
    // if key not exist, add the key and its options

    if (checkString == foodAmount_all) {
      if (widget.selectedFilter.contains(checkString)) {
        widget.selectedFilter.remove(checkString);
        widget.selectedFilter.remove(foodAmount_free);
        widget.selectedFilter.remove(foodAmount_chargeable);
      } else {
        widget.selectedFilter.add(checkString);
        widget.selectedFilter.add(foodAmount_free);
        widget.selectedFilter.add(foodAmount_chargeable);
      }
    } else if (checkString == foodAvailability_all) {
      if (widget.selectedFilter.contains(checkString)) {
        widget.selectedFilter.remove(checkString);
        widget.selectedFilter.remove(foodAvailability_available);
        widget.selectedFilter.remove(foodAvailability_just_gone);
      } else {
        widget.selectedFilter.add(checkString);
        widget.selectedFilter.add(foodAvailability_available);
        widget.selectedFilter.add(foodAvailability_just_gone);
      }
    } else if (checkString == foodType_all) {
      if (widget.selectedFilter.contains(checkString)) {
        widget.selectedFilter.remove(checkString);
        widget.selectedFilter.remove(foodType_veg);
        widget.selectedFilter.remove(foodType_non_veg);
      } else {
        widget.selectedFilter.add(checkString);
        widget.selectedFilter.add(foodType_veg);
        widget.selectedFilter.add(foodType_non_veg);
      }
    } else {
      if (widget.selectedFilter.contains(checkString)) {
        widget.selectedFilter.remove(checkString);
      } else {
        widget.selectedFilter.add(checkString);
      }
    }
    // check if both keys are present then add add key
    if (checkString != foodAmount_all ||
        checkString != foodType_all ||
        checkString != foodAvailability_all) {
      // check if both options are present then add all key
      if (widget.selectedFilter.contains(foodAmount_free) &&
          widget.selectedFilter.contains(foodAmount_chargeable)) {
        // add all key
        widget.selectedFilter.add(foodAmount_all);
      }

      if (widget.selectedFilter.contains(foodAvailability_available) &&
          widget.selectedFilter.contains(foodAvailability_just_gone)) {
        // add all key
        widget.selectedFilter.add(foodAvailability_all);
      }

      if (widget.selectedFilter.contains(foodType_veg) &&
          widget.selectedFilter.contains(foodType_non_veg)) {
        // add all key
        widget.selectedFilter.add(foodType_all);
      }
    }
    reloadScreen_notifyParentAboutSelection();
  }

  void reloadScreen_notifyParentAboutSelection() {
    widget.onFilterSelected(widget.selectedFilter, widget.distanceSelected);
    setState(() {});
  }
}
