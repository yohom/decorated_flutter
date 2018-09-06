import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const ImageWidget({
    @required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: CircularProgressIndicator(),
      errorWidget: Icon(Icons.error),
      fit: fit,
    );
  }
}
