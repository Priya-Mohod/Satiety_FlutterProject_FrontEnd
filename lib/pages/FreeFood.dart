import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:satietyfrontend/pages/service.dart';

class AddFreeFood extends StatelessWidget {
  AddFreeFood({super.key});

  final _free_food_formfield = GlobalKey<FormState>();
  final freeFoodNameController = TextEditingController();
  final freeFoodDescriptionController = TextEditingController();
  final freeFoodQuantityController = TextEditingController();
  final freeFoodAddressController = TextEditingController();

  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //add back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Free Food',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _free_food_formfield,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: freeFoodNameController,
                  decoration: const InputDecoration(
                    labelText: "Food Name",
                    prefixIcon: Icon(Icons.food_bank),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: freeFoodDescriptionController,
                  decoration: const InputDecoration(
                    labelText: "Food Description",
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: freeFoodQuantityController,
                  decoration: const InputDecoration(
                    labelText: "Enter number",
                    prefixIcon: Icon(Icons.production_quantity_limits),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: freeFoodAddressController,
                  decoration: const InputDecoration(
                    labelText: "Enter Pickup Location and",
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.none,
                  decoration: const InputDecoration(
                    labelText: "Add up to 10 images",
                    prefixIcon: Icon(Icons.add_a_photo),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.red,
                    elevation: 15,
                    minimumSize: const Size(200, 50),
                  ),
                  onPressed: () {
                    service.saveFoodDetails(
                        freeFoodNameController.text,
                        freeFoodDescriptionController.text,
                        int.parse(freeFoodQuantityController.text),
                        freeFoodAddressController.text);

                    print("Food Name: ${freeFoodNameController.text}");
                    print(
                        "Food Description: ${freeFoodDescriptionController.text}");
                    print("Food Quantity: ${freeFoodQuantityController.text}");
                    print("Food Address: ${freeFoodAddressController.text}");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddFreeFood(),
                        ));
                  },
                  child: const Text('Add Food', style: TextStyle(fontSize: 30)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
