import 'package:flutter/material.dart';

class DualImageWidget extends StatelessWidget {
  final FileImage? fileImage;
  final NetworkImage? networkImage;
  final String? defaultImageUrl;

  DualImageWidget({this.fileImage, this.networkImage, this.defaultImageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (fileImage != null)
          Image(image: fileImage!)
        else if (networkImage != null)
          Image(image: networkImage!)
        else if (defaultImageUrl != null)
          Image.network(defaultImageUrl!)
        else
          Center(
              child: Text(
                  'No image available')), // Default text if no image is provided
      ],
    );
  }
}
