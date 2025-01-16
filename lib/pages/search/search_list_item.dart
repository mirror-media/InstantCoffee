import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/vertex_search_article.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';

class SearchListItem extends StatelessWidget {
  const SearchListItem(this.article, {Key? key}) : super(key: key);
  final VertexSearchArticle article;

  @override
  Widget build(BuildContext context) {
    double imageSize = 25 * (Get.width - 32) / 100;
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    article.derivedStructData?.title ??
                        StringDefault.valueNullDefault,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                CustomCachedNetworkImage(
                  height: imageSize,
                  width: imageSize,
                  imageUrl: article.heroImagePath,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onTap: () => RouteGenerator.navigateToStory(
        article.slug,
      ),
    );
  }
}
