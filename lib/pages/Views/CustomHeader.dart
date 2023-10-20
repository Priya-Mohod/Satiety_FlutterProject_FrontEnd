import 'package:flutter/material.dart';

class CustomHeader extends StatefulWidget {
  final String title;
  final String profileImageURL;
  final double height;

  CustomHeader(
      {required this.title,
      required this.profileImageURL,
      required this.height});

  @override
  _CustomHeaderState createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.red[600], // Set the background color for the header
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 50.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 50.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.profileImageURL),
                radius: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
