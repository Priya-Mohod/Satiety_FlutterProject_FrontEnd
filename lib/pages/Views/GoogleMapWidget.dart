import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/StringConstants.dart';

class GoogleMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;

  const GoogleMapWidget({required this.latitude, required this.longitude});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      // TODO : Check for null location and handle it
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: 15,
      ),
      // how to get current controllerx
      // markers: _markers,
      markers: {
        Marker(
          markerId: MarkerId("demo"),
          position: LatLng(widget.latitude, widget.longitude),
          draggable: true,
          infoWindow: InfoWindow(
            title: StringConstants.food_details_map_marker,
          ),
        )
      },
      // on Tap open google map mobile application
      onTap: (LatLng latLng) {
        _onMapTapped(LatLng(widget.latitude, widget.longitude));
      },
    );
  }

  void _onMapTapped(LatLng latLng) async {
    const String url = "comgooglemaps://";

    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      _launchGoogleMaps(latLng);
    } else {
      openMapWithMapKit(latLng.latitude, latLng.longitude);
    }
  }

  Future<void> openMapWithMapKit(double latitude, double longitude) async {
    final String url = "http://maps.apple.com/?ll=$latitude,$longitude";

    Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await canLaunchUrl(uri);
      } else {
        throw "Could not launch maps";
      }
    } catch (e) {
      print("Error launching URL: $e");
    }
  }

  Future<void> _launchGoogleMaps(LatLng latLng) async {
    final String mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';

    Uri uri = Uri.parse(mapsUrl);

    if (await canLaunchUrl(uri)) {
      await canLaunchUrl(uri);
    } else {
      throw 'Could not launch Google Maps.';
    }
  }
}
