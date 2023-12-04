import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../helpers/environment.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double? height;


  const CustomCachedNetworkImage(
      {Key? key,
      required this.imageUrl,
      required this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: height,
        width: width,
        child: Image.network(Environment().config.mirrorMediaNotImageUrl),
      ),
      fit: BoxFit.cover,
    );
  }
}
