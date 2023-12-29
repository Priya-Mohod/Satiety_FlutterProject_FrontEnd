import 'package:flutter/material.dart';

class ImageLoader extends StatefulWidget {
  final String imageUrl;
  final double imageHeight;
  final double imageWidth;

  ImageLoader({
    required this.imageUrl,
    required this.imageHeight,
    required this.imageWidth,
  });
  BoxFit customBoxFit = BoxFit.cover;

  @override
  State<ImageLoader> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          widget.imageUrl,
          height: widget.imageHeight,
          width: widget.imageWidth,
          fit: widget.customBoxFit,
        ),
      ],
    );
  }
}
