import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    @required this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder = const CupertinoActivityIndicator(),
  });

  final String imageUrl;
  final BoxFit fit;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: placeholder,
      errorWidget: Icon(Icons.error),
      fit: fit,
    );
  }
}
