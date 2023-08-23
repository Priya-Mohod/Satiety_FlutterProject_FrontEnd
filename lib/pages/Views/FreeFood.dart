import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:satietyfrontend/pages/Views/ListView.dart';
import 'package:satietyfrontend/pages/Views/SupplierLocationMap.dart';
import 'package:satietyfrontend/pages/getData.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../Constants/LocationManager.dart';
import '../Constants/StringConstants.dart';
import 'SnackbarHelper.dart';

class AddFreeFood extends StatefulWidget {
  const AddFreeFood({super.key});

  @override
  State<AddFreeFood> createState() => _AddFreeFoodState();
}

class _AddFreeFoodState extends State<AddFreeFood> {
  final _free_food_formfield = GlobalKey<FormState>();
  final foodNameController = TextEditingController();
  final foodDescriptionController = TextEditingController();
  //final foodAddressController =  TextEditingController(); // Just declared not used
  final foodImageUriController =
      TextEditingController(); // Just declared not used
  final customAllergyController = TextEditingController();
  final foodAmountController = TextEditingController();
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;
  Service service = Service();
  Data data = Data();

  File? image;
  final picker = ImagePicker();
  bool showSpinner = false;
  //var locationData;

  GoogleMapController? _mapController;
  Set<Marker> markers = {};
  String userAddress = '';
  final TextEditingController foodAddressController = TextEditingController();
  int selectedFoodQuantity = 1;
  String selectedFoodType = "Both"; // TODO:- Create enum for food type
  bool hasAllergyContent = false; // Variable to track Yes/No selection
  String selectedAllergy = ''; // Variable to store selected allergy content
  // List of allergy options for the dropdown
  List<String> allergyOptions = [
    'Gluten',
    'Dairy',
    'Nuts',
    'Shellfish',
    'Soy',
    'Eggs',
    'Others'
    // Add more unique allergy options as needed
  ];
  bool applyChargesOnFood = false;

  // Set to store selected food allergies
  Set<String> selectedAllergies = {};

  // Variable to store user's custom allergy text
  String customAllergyText = '';
  String allergyContentString = '';

  // Key to identify the allergy options area
  final _allergyOptionsKey = GlobalKey();

  // Overlay entry to show the allergy options
  OverlayEntry? _allergyOptionsOverlay;

  DateTime foodAvailableDate = DateTime.now();
  TimeOfDay foodAvailableFromTime = TimeOfDay.now();
  TimeOfDay foodAvailableToTime = TimeOfDay.now();

  var locationData;
  LatLng userCoordinates = LatLng(0.0, 0.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // locationData = _requestLocationPermission();
    foodAddressController.text = userAddress;
    // _determinePosition();
    getLocation();
  }

  Future getLocation() async {
    try {
      locationData = await LocationManager().determinePosition();
      // Update Map Location
      setMarker_AnimateCamera_userLocation(locationData);
    } catch (e) {
      SnackbarHelper.showSnackBar(
          context, StringConstants.location_update_error);
    }
  }

  Future setMarker_AnimateCamera_userLocation(dynamic location) async {
    // Update Map Location
    userCoordinates = LatLng(location.latitude, location.longitude);

    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(userCoordinates.toString()),
        position: userCoordinates,
        infoWindow: const InfoWindow(
          title: 'Pick up location',
        ),
      ));
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(userCoordinates),
    );

    foodAddressController.text = await LocationManager()
        .getAddressFromCoordinates(
            userCoordinates.latitude, userCoordinates.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //add back button
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.red),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/ListViewPage');
            },
          ),
          title: const Text(
            'Add Food',
            style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Handle tap outside the allergy options area
            setState(() {
              _hideAllergyOptions();
            });
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _free_food_formfield,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 10),
                        if (image != null)
                          Image.file(File(image!.path).absolute,
                              width: 100, height: 100),
                        // SizedBox(height: 10),
                        IconButton(
                          color: Colors.cyan,
                          onPressed: _showImagePickerOptions,
                          icon: const Icon(Icons.add_a_photo, size: 50),
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.black, // Color of the line
                      height: 30, // Thickness of the line
                    ),
                    //SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      controller: foodNameController,
                      decoration: const InputDecoration(
                        labelText: "Food Name",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        prefixIcon: Icon(
                          Icons.food_bank,
                          size: 30,
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 20),
                      controller: foodDescriptionController,
                      decoration: const InputDecoration(
                        labelText: "Food Description",
                        prefixIcon: Icon(
                          Icons.description_outlined,
                          size: 30,
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // show drop down here

                    Text.rich(TextSpan(
                      text: 'Select Serving Quantity : ',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              '${selectedFoodQuantity != 0 ? selectedFoodQuantity : "None"}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 28, 145, 181),
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    )),
                    SizedBox(height: 10),
                    // Text(
                    //   'Select Serving Quantity : ${selectedQuantity != 0 ? selectedQuantity : "None"}',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    Wrap(
                      spacing: 8.0,
                      children: List.generate(
                        6,
                        (index) => ChoiceChip(
                          label: Text('${index + 1}'),
                          selected: selectedFoodQuantity == index + 1,
                          onSelected: (isSelected) {
                            setState(() {
                              selectedFoodQuantity =
                                  isSelected ? index + 1 : selectedFoodQuantity;
                            });
                          },
                          backgroundColor: Color.fromARGB(255, 84, 222, 241),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text.rich(TextSpan(children: <TextSpan>[
                      const TextSpan(
                        text: 'Selected Food Type:  ',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '$selectedFoodType',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 24.0,
                          color: Color.fromARGB(255, 33, 160, 172),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])),

                    SizedBox(height: 10),

                    Wrap(
                      spacing: 8.0,
                      children: [
                        buildChoiceChip('Veg'),
                        buildChoiceChip('Non-Veg'),
                        buildChoiceChip('Both'),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    Text(
                      'Sleect Food Availability Date and Time :',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    //   ],
                    // ),

                    SizedBox(height: 10),

                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text(DateFormat('dd-MM-yyyy')
                              .format(foodAvailableDate)),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => _selectStartTime(context),
                          child: Text(foodAvailableFromTime.format(context)),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '-',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _selectEndTime(context),
                          child: Text(foodAvailableToTime.format(context)),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Show Allergy option here - Yes/No
                    // TODO :- devide this into a separate widget
                    Row(
                      children: [
                        const Text(
                          'Has Allergy Content?',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<bool>(
                          value: hasAllergyContent,
                          onChanged: (value) {
                            setState(() {
                              hasAllergyContent = value!;
                              if (!hasAllergyContent) {
                                selectedAllergies
                                    .clear(); // Clear selected allergies if user selects 'No'
                                customAllergyText =
                                    ''; // Clear custom allergy text
                              } else {
                                // Show allergy options when user selects 'Yes'
                                _allergyOptionsKey;
                              }
                            });
                          },
                          items: const [
                            DropdownMenuItem<bool>(
                              value: true,
                              child: Text('Yes'),
                            ),
                            DropdownMenuItem<bool>(
                              value: false,
                              child: Text('No'),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Checkboxes for selecting allergy content
                    if (hasAllergyContent) // Show only if user selected 'Yes'
                      Column(
                        key: _allergyOptionsKey,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: allergyOptions.map((allergy) {
                          if (allergy == 'Others') {
                            return Column(
                              children: [
                                CheckboxListTile(
                                  title: Text(allergy),
                                  value: selectedAllergies.contains(allergy),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedAllergies.add(allergy);
                                        selectedAllergies
                                            .remove(customAllergyText);
                                      } else {
                                        selectedAllergies.remove(allergy);
                                        if (customAllergyText.isNotEmpty) {
                                          selectedAllergies
                                              .add(customAllergyText);
                                        }
                                      }
                                    });
                                  },
                                ),
                                if (selectedAllergies.contains(allergy))
                                  // Show text box only when "Others" is selected
                                  TextFormField(
                                    controller: customAllergyController,
                                    decoration: const InputDecoration(
                                        labelText: 'Enter Custom Allergy'),
                                    onChanged: (newText) {
                                      setState(() {
                                        customAllergyText = newText;
                                      });
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        selectedAllergies
                                            .add(customAllergyText);
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                              ],
                            );
                          } else {
                            return CheckboxListTile(
                              title: Text(allergy),
                              value: selectedAllergies.contains(allergy),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedAllergies.add(allergy);
                                  } else {
                                    selectedAllergies.remove(allergy);
                                  }
                                });
                              },
                            );
                          }
                        }).toList(),
                      ),

                    // Show Food Cost - Free of Cost / Chargeable
                    // TODO :- devide this into a separate widget
                    Row(
                      children: [
                        const Text(
                          'Do you want to charge for the food?',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<bool>(
                          value: applyChargesOnFood,
                          onChanged: (value) {
                            setState(() {
                              applyChargesOnFood = value!;
                            });
                          },
                          items: const [
                            DropdownMenuItem<bool>(
                              value: true,
                              child: Text('Yes'),
                            ),
                            DropdownMenuItem<bool>(
                              value: false,
                              child: Text('No'),
                            ),
                          ],
                        ),
                      ],
                    ),

                    if (applyChargesOnFood == true)
                      TextFormField(
                        controller: foodAmountController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                          labelText: "Food Amount",
                          prefixIcon: Icon(
                            Icons.attach_money,
                            size: 30,
                            color: Colors.cyan,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the food amount';
                          }

                          return null;
                        },
                      ),

                    SizedBox(height: 10),
                    // show map here to select address
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      controller: foodAddressController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: StringConstants.post_ad_user_address,
                        prefixIcon: Icon(Icons.add_location),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Ask user to turn on location if not turned on

                    // Add Apple Maps here
                    SizedBox(
                      height: 200,
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          setState(() {
                            markers.clear();
                            markers.add(Marker(
                              markerId: MarkerId(userCoordinates.toString()),
                              position: userCoordinates,
                              infoWindow: InfoWindow(
                                title: "Selected Location",
                              ),
                            ));
                          });
                        },
                        initialCameraPosition: CameraPosition(
                          target: userCoordinates,
                          zoom: 15,
                        ),
                        markers: markers,
                        onTap: (LatLng location) async {
                          userCoordinates = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupplierLocationMap(
                                  selectedLocation: userCoordinates),
                            ),
                          );
                          setMarker_AnimateCamera_userLocation(userCoordinates);
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.black,
                          shadowColor: Colors.red,
                          elevation: 15,
                          minimumSize: const Size(200, 50),
                        ),
                        onPressed: () async {
                          // Check if user has selected an image
                          if (image == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(StringConstants.post_ad_image_select),
                              ),
                            );
                            return;
                          }

                          // Check if user has entered food name
                          if (foodNameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    StringConstants.post_ad_enter_food_name),
                              ),
                            );
                            return;
                          }

                          // Check if user has entered food description
                          if (foodDescriptionController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter food description'),
                              ),
                            );
                            return;
                          }

                          // Check if user has selected food amount
                          if (applyChargesOnFood == true &&
                              foodAmountController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter food amount'),
                              ),
                            );
                            return;
                          }

                          allergyContentString = selectedAllergies.join(', ');
                          if (selectedAllergies.contains('Others')) {
                            // Add custom allergy text to the string if it is not empty
                            print(customAllergyController.text);
                            String customAllergyText_inController =
                                customAllergyController.text;
                            selectedAllergies.remove('Others');
                            allergyContentString +=
                                " : " + customAllergyText_inController;
                            print(allergyContentString);
                          }
                          print(allergyContentString);

                          Map<String, String> foodTime =
                              getFoodAvailableDateTime();

                          var response = await service.sendFoodDetailsWithFile(
                            foodNameController.text,
                            foodDescriptionController.text,
                            selectedFoodQuantity,
                            foodAddressController.text,
                            foodImageUriController.text,
                            selectedFoodType,
                            image,
                            userCoordinates.latitude,
                            userCoordinates.longitude,
                            allergyContentString,
                            foodAmountController.text,
                            foodTime['fromTime']!,
                            foodTime['toTime']!,
                          );

                          // log event add food
                          await logAddFoodEvent(foodNameController.text);

                          // show alert dialog on condition
                          if (response) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Add Food'),
                                content: const Text('Food added successfully'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ListViewPage(),
                                          ));
                                      // TODO:- clear the form fields
                                      // TODO:- clear the image
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Add Food'),
                                content: const Text(
                                    'Food not added, there was an error, please try again'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // hide the alert dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text('Add Food',
                            style: TextStyle(fontSize: 30)),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ));
    // Function to add a marker on the map and animate the camera to the marker's position
  }

  Widget buildChoiceChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedFoodType == label,
      onSelected: (isSelected) {
        setState(() {
          selectedFoodType = isSelected ? label : selectedFoodType;
        });
      },
    );
  }

  // Function to hide the allergy options
  void _hideAllergyOptions() {
    if (_allergyOptionsOverlay != null) {
      _allergyOptionsOverlay!.remove();
      _allergyOptionsOverlay = null;
    }
    if (customAllergyText.isNotEmpty) {
      selectedAllergies.add(customAllergyText);
    }
  }

  Future<void> logAddFoodEvent(String foodName) async {
    await _firebaseAnalytics.logEvent(
      name: 'add_food', // Event name, you can use any name you want
      parameters: {'food_name': foodName},
    );
  }

  void _showImagePickerOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: foodAvailableDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 1)),
    );

    if (picked != null && picked != foodAvailableDate) {
      setState(() {
        foodAvailableDate = picked;
        foodAvailableFromTime = TimeOfDay.now();
        foodAvailableToTime = TimeOfDay.now();
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay currentTime = TimeOfDay.now();
    DateTime currentDate = DateTime.now();
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: currentTime);
    bool setStartTime = false;
    if (picked != null && picked != foodAvailableFromTime) {
      // check if selected day is greater than current day
      if (currentDate == foodAvailableDate) {
        if ((picked.hour > currentTime.hour) ||
            (picked.hour == currentTime.hour &&
                picked.minute > currentTime.minute)) {
          setStartTime = true;
        }
      } else {
        setStartTime = true;
      }
    }

    if (setStartTime == true) {
      setState(() {
        foodAvailableFromTime = picked!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid time'),
        ),
      );
      setState(() {
        foodAvailableFromTime = TimeOfDay.now();
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: foodAvailableToTime,
    );

    if (picked != null && picked != foodAvailableToTime) {
      if ((picked.hour > foodAvailableFromTime.hour) ||
          (picked.hour == foodAvailableFromTime.hour &&
              picked.minute > foodAvailableFromTime.minute)) {
        setState(() {
          foodAvailableToTime = picked;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be greater than start time'),
          ),
        );
        setState(() {
          foodAvailableToTime = TimeOfDay.now();
        });
      }
    }
  }

  Map<String, String> getFoodAvailableDateTime() {
    // --  Date format --
    DateTime combinedFromDateTime = DateTime(
      foodAvailableDate.year,
      foodAvailableDate.month,
      foodAvailableDate.day,
      foodAvailableFromTime.hour,
      foodAvailableFromTime.minute,
    );

    DateTime combinedToDateTime = DateTime(
      foodAvailableDate.year,
      foodAvailableDate.month,
      foodAvailableDate.day,
      foodAvailableToTime.hour,
      foodAvailableToTime.minute,
    );

    String formattedFromDateTime =
        combinedFromDateTime.toIso8601String().split('.')[0];
    String formattedToDateTime =
        combinedToDateTime.toIso8601String().split('.')[0];
    print(formattedFromDateTime);
    print(formattedToDateTime);

    // return [formattedFromDateTime, formattedToDateTime];
    return {"fromTime": formattedFromDateTime, "toTime": formattedToDateTime};
  }
}
