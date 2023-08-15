//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/Messegepage.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/Views/GoogleMapWidget.dart';
import 'package:satietyfrontend/pages/Views/ListView.dart';
import 'package:satietyfrontend/pages/Views/MyRequests.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import 'package:satietyfrontend/pages/allergyPage.dart';
import 'package:satietyfrontend/pages/ViewModels/requestProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constatnts/StringConstants.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';

class FoodDetails extends StatefulWidget {
  final FoodItem foodItem;

  const FoodDetails({required this.foodItem});

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //add back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 35),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.foodItem.foodName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.foodItem.foodSignedUrl,
                height: 400, fit: BoxFit.cover, width: double.infinity),
            Container(
                color: Color.fromARGB(255, 192, 209, 212),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.share, size: 35),
                    SizedBox(width: 10),
                    Icon(Icons.favorite_border, size: 35),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.foodItem.addedByUserName} is giving away!',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Row(
                    children: [
                      Icon(Icons.account_circle, size: 50),
                      SizedBox(width: 10),
                      Text(widget.foodItem.addedByUserName,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Food Description: ${widget.foodItem.foodDescription}',
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 215, 233, 235),
                      foregroundColor: Colors.black,
                      //shadowColor: Color.fromARGB(255, 152, 218, 226),
                      elevation: 4,
                      minimumSize: const Size(390, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllergyInfo(),
                          ));
                    },
                    child: const Text(
                      'View Food Allergen Information Here',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Food Quantity: ${widget.foodItem.foodQuantity}',
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20),
              enabled: false,
              decoration: InputDecoration(
                labelText: widget.foodItem.foodAddress,
                prefixIcon: Icon(Icons.add_location),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: GoogleMapWidget(
                  latitude: widget.foodItem.latitude,
                  longitude: widget.foodItem.longitude),
            ),
            SizedBox(height: 20),
            Center(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black,
                shadowColor: Colors.red,
                elevation: 15,
                minimumSize: const Size(250, 50),
              ),
              onPressed: () async {
                var response =
                    await service.requestFood(widget.foodItem.foodId);
                if (response) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(StringConstants.food_details_request_button),
                      content:
                          Text(StringConstants.food_details_request_success),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Make server call to request food
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Navigator(
                                  onGenerateRoute: (settings) {
                                    return MaterialPageRoute(
                                        builder: (context) => MyRequests());
                                  },
                                ),
                              ),
                            );

                            // TODO:- clear the form fields
                            // TODO:- clear the image
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // show error message
                  SnackbarHelper.showSnackBar(
                      context, StringConstants.food_details_request_failed);
                }
              },
              child: const Text('Request This',
                  style: TextStyle(
                    fontSize: 30,
                  )),
            )),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
