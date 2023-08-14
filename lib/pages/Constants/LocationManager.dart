import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationManager {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle the
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    // Check if the app has location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, handle the scenario
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Check if the app has location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permissions are denied, ask user for permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        return Future.error(
            'Location permissions are denied, we cannot request permissions.');
      }
    }

    // Location permissions are granted
    // get location here
    final locationData = await Geolocator.getCurrentPosition();
    print(locationData.latitude);
    print(locationData.longitude);
    print(locationData.accuracy);

    // get address here
    List<Placemark> placemark = await placemarkFromCoordinates(
        locationData.latitude, locationData.longitude);
    print(placemark);
    Placemark place = placemark[0];

    //print(userAddress);

    // setState(() {
    //   //_addMarker(locationData.latitude, locationData.longitude);
    //   userCoordinates = LatLng(locationData.latitude, locationData.longitude);
    //   userAddress =
    //       "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
    //   foodAddressController.text = userAddress;
    //   print(userAddress);
    //   // show toast here
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("User Address Updated!"),
    //     ),
    //   );
    // });

    return locationData;
  }
}
