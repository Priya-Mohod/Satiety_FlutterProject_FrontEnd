import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/StringConstants.dart';

class InfoGuide extends StatefulWidget {
  const InfoGuide({super.key});

  @override
  State<InfoGuide> createState() => _InfoGuideState();
}

class _InfoGuideState extends State<InfoGuide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(' Guide',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'calibri',
            )),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Icon Guide',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'calibri',
                  )),
              Container(
                color: Colors.cyan[100],
                height: 700,
                //width: 400,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 30,
                              color: Colors.red[900],
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 300,
                              child: Text(
                                StringConstants.info_guide_Location_msg,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'calibri',
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fastfood,
                                color: Color.fromARGB(255, 40, 125, 43),
                                size: 30),
                            SizedBox(width: 10),
                            Container(
                              width: 300,
                              child: Text(
                                StringConstants.info_guide_food_type_green,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'calibri',
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fastfood,
                              color: Colors.red,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 300,
                              child: Text(
                                StringConstants.info_guide_food_type_red,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'calibri',
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fastfood,
                                color: Colors.orange, size: 30),
                            SizedBox(width: 10),
                            Container(
                              width: 300,
                              child: Text(
                                StringConstants.info_guide_food_type_orange,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'calibri',
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.currency_rupee_rounded,
                              size: 30,
                              color: Colors.green[800],
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 300,
                              child: Text(
                                StringConstants.info_guide_price_green,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'calibri',
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.currency_rupee_rounded,
                              size: 30,
                              color: Colors.red[900],
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 300,
                              child: Text(
                                StringConstants.info_guide_price_red,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'calibri',
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
