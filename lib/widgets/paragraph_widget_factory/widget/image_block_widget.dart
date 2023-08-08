import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/models/article_info/children_model/paragraph_model/paragraph.dart';

class ImageBlockWidget extends StatelessWidget {
  final Paragraph paragraph;

  const ImageBlockWidget(this.paragraph, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = paragraph.contents?[0].data;
    final imageDescription = paragraph.contents?[0].description;
    final imageHeight =
        Get.width * (paragraph.contents?[0].aspectRatio ?? (16 / 9));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        if (imageUrl != null)
          InkWell(
            onTap: () {},
            child: CachedNetworkImage(
              width: Get.width,
              imageUrl: imageUrl,
              placeholder: (context, url) => Container(
                height: imageHeight,
                width: Get.width,
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => Container(
                height: imageHeight,
                width: Get.width,
                color: Colors.grey,
                child: const Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
          ),
        if (imageDescription != null) ...[
          const SizedBox(height: 12),
          const Divider(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            thickness: 1,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              imageDescription,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 12),
        ]
      ],
    );
  }
}
