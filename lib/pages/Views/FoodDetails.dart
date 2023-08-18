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
import '../Constants/StringConstants.dart';
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListViewPage()));
          },
        ),
        title: Text(
          widget.foodItem.foodName,
          style: TextStyle(
            color: Colors.grey[850],
            fontSize: 25,
            //fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.foodItem.foodSignedUrl,
                height: 350, fit: BoxFit.cover, width: double.infinity),
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
              padding: const EdgeInsets.fromLTRB(15, 15, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.account_circle,
                          size: 50, color: Colors.redAccent[100]),
                      SizedBox(width: 10),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${widget.foodItem.addedByUserName} is giving away!',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                            // Title(
                            //   color: Colors.black,
                            //   child: Text(
                            //     widget.foodItem.foodName,
                            //     style: TextStyle(
                            //         fontSize: 30, fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            Text(widget.foodItem.foodName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                )),
                            Row(
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 5),
                                Text('Added 1 day ago',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[600],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(widget.foodItem.foodDescription,
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: 350,
                    color: Colors.blueGrey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: _launchURL,
                        child: Text(
                          StringConstants.food_details_allergy_String,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            //decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Quantity: ${widget.foodItem.foodQuantity}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      )),
                  SizedBox(height: 25),
                  Text('Pick-Up Times',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      )),
                  SizedBox(height: 8),
                  Text('From 4 to 6',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black54,
                      )),
                  SizedBox(height: 25),
                  Container(
                    color: Color.fromARGB(255, 215, 233, 235),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(TextSpan(
                        text: 'Today ${widget.foodItem.addedByUserName} is ',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.foodItem.foodAmount == 0.0
                                ? "Giving Free"
                                : 'Charging Rs. ${widget.foodItem.foodAmount}',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: widget.foodItem.foodAmount == 0.0
                                  ? Color.fromARGB(255, 40, 125, 43)
                                  : Colors.red[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          TextSpan(
                            text: ' for ',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                          if (widget.foodItem.foodType == 'Non-Veg')
                            TextSpan(
                              text: ' non-veg',
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.red[900],
                              ),
                            ),
                          if (widget.foodItem.foodType == 'Veg')
                            TextSpan(
                              text: ' veg ',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                          if (widget.foodItem.foodType == 'Both')
                            TextSpan(
                              text: ' veg and non-veg both',
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.orange[900],
                              ),
                            ),
                          TextSpan(
                            text: ' meal.',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                  SizedBox(height: 10),
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

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://www.food.gov.uk/business-guidance/allergen-guidance-for-food-businesses');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
