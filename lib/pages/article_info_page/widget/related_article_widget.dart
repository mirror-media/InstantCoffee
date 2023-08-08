import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/core/values/string.dart';

import '../../../models/post/post_model.dart';

class RelatedArticleWidget extends StatelessWidget {
  final List<PostModel> postList;
  final Function(String?) itemClickEvent;

  const RelatedArticleWidget({Key? key, required this.postList, required this.itemClickEvent})
      : super(key: key);

  Widget _buildRelatedItem(PostModel relatedItem) {
    double imageWidth = 84;
    double imageHeight = 84;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 16.0, 0.0, 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: imageHeight,
              width: imageWidth,
              imageUrl: relatedItem.heroImage?.imageCollection?.original ?? '',
              placeholder: (context, url) => Container(
                height: imageHeight,
                width: imageWidth,
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => Container(
                height: imageHeight,
                width: imageWidth,
                color: Colors.grey,
                child: const Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                relatedItem.title ?? StringDefault.valueNullDefault,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color.fromRGBO(0, 0, 0, 0.66),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        itemClickEvent(relatedItem.slug);

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [...postList.map((e) => _buildRelatedItem(e)).toList()],
    );
  }
}
