class DevelopementConfig {
  final bool showInKM = true;
  // getter for showInKM
  bool get getShowInKM => showInKM;
  final GOOGLE_MAP_KEY = 'AIzaSyDFkgk7N-JkiLHOEDowS6LH7q-bIP1nRF0';
  //final apiKey = 'AIzaSyDFkgk7N-JkiLHOEDowS6LH7q-bIP1nRF0';
}

enum Pages { Home, MyListings, Add, MyRequests, Messages, Unknown }

enum DistanceFilter { five, seven, nine, twelve, fifteen, twenty, thirty, none }
