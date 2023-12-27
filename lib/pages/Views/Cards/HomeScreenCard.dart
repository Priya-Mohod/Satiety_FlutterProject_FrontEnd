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
        padding: const EdgeInsets.all(4.0),
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
            height: 120,
            // color: Colors.black54,
            child: Row(
              children: [
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
                            widget.foodItem.foodSignedUrl,
                            height: 120,
                            width: 130,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/account.png',
                                height: 120,
                                width: 130,
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
                                  child: CircularProgressIndicator(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 05),
                          Text(widget.foodItem.foodName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(height: 05),
                          Container(
                            width: 200,
                            child: Row(
                              children: [
                                ClipOval(
                                    child: Image.network(
                                  widget.foodItem.addedByUserImageUrl,
                                  height: 40,
                                  width: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/account.png',
                                      height: 30,
                                      width: 30,
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
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                )),
                                SizedBox(width: 3),
                                Expanded(
                                  child: Text(widget.foodItem.addedByUserName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                        overflow: TextOverflow.ellipsis,
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
                                  DevelopementConfig().getShowInKM
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
                                const Icon(Icons.fastfood,
                                    color: Color.fromARGB(255, 40, 125, 43),
                                    size: 20),
                              if (widget.foodItem.foodType == 'Non-Veg')
                                const Icon(Icons.fastfood,
                                    color: Colors.red, size: 20),
                              if (widget.foodItem.foodType == 'Both')
                                const Icon(Icons.fastfood,
                                    color: Colors.orange, size: 20),
                              SizedBox(width: 20),
                              if (widget.foodItem.foodAmount == 0.0)
                                Icon(
                                  Icons.currency_rupee_rounded,
                                  size: 20,
                                  color: Colors.green[800],
                                ),
                              if (widget.foodItem.foodAmount != 0.0)
                                Icon(
                                  Icons.currency_rupee_rounded,
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
  }
}
