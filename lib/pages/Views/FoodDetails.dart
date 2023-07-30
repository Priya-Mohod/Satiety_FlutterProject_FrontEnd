import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:satietyfrontend/pages/Forumpage.dart';
import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';

class FoodDetails extends StatelessWidget {
  final FoodItem foodItem;

  const FoodDetails({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //add back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Food Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    foodItem.foodName,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Image.network(foodItem.foodSignedUrl,
                height: 400, fit: BoxFit.cover, width: double.infinity),

            Container(
                color: Color.fromARGB(255, 192, 209, 212),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.share, size: 35),
                    SizedBox(width: 10),
                  ],
                )),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('@username is giving away!',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Row(
                    children: const [
                      Icon(Icons.account_circle, size: 50),
                      SizedBox(width: 10),
                      Text('User Name',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Food Description: ${foodItem.foodDescription}',
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
                            builder: (context) => ForumPage(),
                          ));
                    },
                    child: const Text(
                      'View Food Allergen Information Here',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Food Quantity: ${foodItem.foodQuantity}',
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
