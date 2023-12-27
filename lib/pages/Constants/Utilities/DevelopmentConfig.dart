class DevelopmentConfig {
  final bool showInKM = true;
  // getter for showInKM
  bool get getShowInKM => showInKM;
  final GOOGLE_MAP_KEY = 'AIzaSyDFkgk7N-JkiLHOEDowS6LH7q-bIP1nRF0';
  //final apiKey = 'AIzaSyDFkgk7N-JkiLHOEDowS6LH7q-bIP1nRF0';
  static final bool loginUsingDummyOTP = false;
}

enum Pages { Home, MyListings, Add, MyRequests, Messages, Unknown }

enum DistanceFilter { five, seven, nine, twelve, fifteen, twenty, thirty, none }

enum FoodFilter {
  foodType_all,
  foodType_veg,
  foodType_non_veg,
  foodAmount_all,
  foodAmount_free,
  foodAmount_chargeable,
  foodAvailability_all,
  foodAvailability_available,
  foodAvailability_just_gone
}

enum LocationStatus {
  deviceLocationNotON,
  locationPermissionDenied,
  bothGranted
}

// final String foodType_all = "All_Veg_Non-Veg";
// final String foodType_veg = "Veg";
// final String foodType_non_veg = "Non-veg";
// final String foodAmount_all = "All_Free_Chargeable";
// final String foodAmount_free = "Free";
// final String foodAmount_chargeable = "Chargeable";
// final String foodAvailability_all = "All_Available_Just Gone";
// final String foodAvailability_available = "Available";
// final String foodAvailability_just_gone = "Just Gone";
