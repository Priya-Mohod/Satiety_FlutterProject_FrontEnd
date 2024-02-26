import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/ParsingUtils.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/Views/FoodDetails.dart';

class HomeScreenCard extends StatefulWidget {
  final FoodItem foodItem;
  const HomeScreenCard({required this.foodItem});

  @override
  _HomeScreenCardState createState() => _HomeScreenCardState();
}

class _HomeScreenCardState extends State<HomeScreenCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
        side: const BorderSide(
            color: Color.fromARGB(255, 128, 172, 177),
            width: 1), // Add border color and width
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetails(foodItem: widget.foodItem),
                ));
          },
          child: Container(
            width: 250,
            height: 100,

            ///**** */
            // color: Colors.black54,
            child: Row(
              children: [
                Container(
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            widget.foodItem.foodSignedUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/image_icon.png',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                // Image has finished loading
                                return child;
                              } else {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator()),
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
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 05),
                          Text(widget.foodItem.foodName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(height: 05),
                          Container(
                            width: 250,
                            child: Row(
                              children: [
                                ClipOval(
                                    child: Image.network(
                                  widget.foodItem.addedByUserImageUrl,
                                  height: 25,
                                  width: 25,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/image_icon.png',
                                      height: 20,
                                      width: 20,
                                    );
                                  },
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      // Image has finished loading
                                      return child;
                                    } else {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator()),
                                      );
                                    }
                                  },
                                )),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(widget.foodItem.addedByUserName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.star_half,
                                  size: 20,
                                  color: Color.fromARGB(255, 215, 109, 9),
                                ),
                                SizedBox(width: 5),
                                Text('3.5',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 20, color: Colors.grey[700]),
                              SizedBox(width: 3),
                              Text(
                                  DevelopmentConfig().getShowInKM
                                      ? (widget.foodItem.distanceInKm ?? '') +
                                          ' km'
                                      : (ParsingUtils.convertKmToMiles(
                                              widget.foodItem.distanceInKm)) +
                                          ' mi',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  )),
                              SizedBox(width: 10),
                              if (widget.foodItem.foodType == 'Veg')
                                const Text('Veg',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 11, 101, 17),
                                        fontWeight: FontWeight.bold)),
                              // Icon(Icons.circle_rounded,
                              //     color: Color.fromARGB(255, 40, 125, 43),
                              //     size: 17),

                              if (widget.foodItem.foodType == 'Non-Veg')
                                const Text(
                                  'Non-veg',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              // Icon(Icons.circle_rounded,
                              //     color: Colors.red, size: 17),
                              if (widget.foodItem.foodType == 'Both')
                                const Text('Mix',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 132, 131, 131),
                                        fontWeight: FontWeight.bold)),
                              // Icon(Icons.circle_rounded,
                              //     color: Colors.orange, size: 17),
                              SizedBox(width: 20),
                              if (widget.foodItem.foodAmount == 0.0)
                                Text('Free',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 132, 131, 131),
                                        fontWeight: FontWeight.bold)),
                              // Icon(
                              //   Icons.currency_rupee_rounded,
                              //   size: 17,
                              //   color: Colors.green[800],
                              //),
                              if (widget.foodItem.foodAmount != 0.0)
                                Text('Chargeable',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 132, 131, 131),
                                        fontWeight: FontWeight.bold)),
                              // Icon(
                              //   Icons.currency_rupee_rounded,
                              //   size: 17,
                              //   color: Colors.red[900],
                              // )
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
  }
}
