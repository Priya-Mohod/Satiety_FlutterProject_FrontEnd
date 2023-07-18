import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:satietyfrontend/pages/ListView.dart';
import 'package:satietyfrontend/pages/getData.dart';
import 'package:satietyfrontend/pages/service.dart';
import 'package:image_picker/image_picker.dart';

class AddFreeFood extends StatefulWidget {
  const AddFreeFood({super.key});

  @override
  State<AddFreeFood> createState() => _AddFreeFoodState();
}

class _AddFreeFoodState extends State<AddFreeFood> {
  final _free_food_formfield = GlobalKey<FormState>();
  final foodNameController = TextEditingController();
  final foodDescriptionController = TextEditingController();
  final foodQuantityController = TextEditingController();
  final foodAddressController = TextEditingController();
  final foodImageUriController = TextEditingController();
  final foodTypeController = TextEditingController();

  Service service = Service();
  Data data = Data();

  File? image;
  final picker = ImagePicker();
  bool showSpinner = false;

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
                  style: TextStyle(fontSize: 20),
                  controller: foodNameController,
                  decoration: const InputDecoration(
                    labelText: "Food Name",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    prefixIcon: Icon(Icons.food_bank),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 20),
                  controller: foodDescriptionController,
                  decoration: const InputDecoration(
                    labelText: "Food Description",
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  controller: foodQuantityController,
                  decoration: const InputDecoration(
                    labelText: "Enter number",
                    prefixIcon: Icon(Icons.production_quantity_limits),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  controller: foodAddressController,
                  decoration: const InputDecoration(
                    labelText: "Enter Pickup Location and",
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  controller: foodTypeController,
                  decoration: const InputDecoration(
                    labelText: "Food Type - Veg/Non-Veg",
                    prefixIcon: Icon(Icons.add_a_photo),
                  ),
                ),
                SizedBox(height: 10),

                // show image here if image is selected
                if (image != null)
                  Image.file(File(image!.path).absolute,
                      width: 200, height: 200),
                SizedBox(height: 10),

                // select image button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.red,
                    elevation: 15,
                    minimumSize: const Size(200, 50),
                  ),
                  onPressed: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (pickedFile != null) {
                      image = File(pickedFile.path);

                      setState(() {});
                    }
                  },
                  child: const Text('Select Image',
                      style: TextStyle(fontSize: 30)),
                ),

                // TextFormField(
                //   keyboardType: TextInputType.text,
                //   style: TextStyle(fontSize: 20),
                //   controller: foodImageUriController,
                //   decoration: const InputDecoration(
                //     labelText: "paste image url here",
                //     prefixIcon: Icon(Icons.add_a_photo),
                //   ),
                // ),
                // SizedBox(height: 20),
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
                    if (image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an image'),
                        ),
                      );
                      return;
                    }
                    service.sendFoodDetailsWithFile(
                        foodNameController.text,
                        foodDescriptionController.text,
                        int.parse(foodQuantityController.text),
                        foodAddressController.text,
                        foodImageUriController.text,
                        foodTypeController.text,
                        image);

                    print("Food Name: ${foodNameController.text}");
                    print(
                        "Food Description: ${foodDescriptionController.text}");
                    print("Food Quantity: ${foodQuantityController.text}");
                    print("Food Address: ${foodAddressController.text}");
                    print("Food Image Uri: ${foodImageUriController.text}");
                    print("Food Type: ${foodTypeController.text}");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListViewPage(),
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
