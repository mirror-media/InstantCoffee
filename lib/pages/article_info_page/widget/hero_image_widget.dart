import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/environment.dart';
import '../../../helpers/route_generator.dart';
import '../../../models/article_info/article_info.dart';
import '../../../widgets/m_m_video_player.dart';

class HeroImageWidget extends StatelessWidget {
  const HeroImageWidget({Key? key, required this.articleInfo}) : super(key: key);
  final ArticleInfo articleInfo;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        articleInfo.heroVideo != null
            ? MMVideoPlayer(
          videourl: articleInfo.heroVideo!,
          aspectRatio: 16 / 9,
        )
            : InkWell(
          onTap: () {
            final url = articleInfo.heroImage?.imageCollection?.original;
            if (url != Environment().config.mirrorMediaNotImageUrl &&
                url != null) {
              List<String> index = [url];
              RouteGenerator.navigateToImageViewer(index);
            }
          },
          child: CachedNetworkImage(
            height: Get.width / 16 * 9,
            width: Get.width,
            imageUrl: articleInfo.heroImage?.imageCollection?.original ?? '',
            placeholder: (context, url) => Container(
              height: Get.width / 16 * 9,
              width: Get.width,
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Container(
              height: Get.width / 16 * 9,
              width: Get.width,
              color: Colors.grey,
              child: const Icon(Icons.error),
            ),
            fit: BoxFit.cover,
          ),
        ),
        if (articleInfo.heroCaption != null && articleInfo.heroCaption != '')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 12),
                Text(
                  articleInfo.heroCaption!,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
      ],
    );
  }
}