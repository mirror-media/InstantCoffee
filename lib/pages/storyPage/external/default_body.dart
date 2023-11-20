import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/core/extensions/string_extension.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/data/enum/external_story_ad_mode.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/models/external_story.dart';
import 'package:readr_app/pages/storyPage/external/external_story_controller.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';
import 'package:readr_app/widgets/m_m_ad_banner.dart';

class DefaultBody extends GetView<ExternalStoryController> {
  final ExternalStory externalStory;

  const DefaultBody({Key? key, required this.externalStory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = width / 16 * 9;

    return Stack(
      children: [
        ListView(children: [
          const SizedBox(height: 16),
          Obx(() {
            final storyAd = controller.rxnStoryAd.value;
            return storyAd != null
                ? MMAdBanner(
                    adUnitId: storyAd.hDUnitId,
                    adSize: AdSize.mediumRectangle,
                    isKeepAlive: true,
                  )
                : const SizedBox.shrink();
          }),
          const SizedBox(height: 16),
          _buildHeroImage(width, height,
              externalStory.heroImage ?? StringDefault.valueNullDefault),
          const SizedBox(height: 32),
          _buildCategoryAndPublishedDate(
              externalStory.publishedDate ?? StringDefault.valueNullDefault),
          const SizedBox(height: 8),
          _buildStoryTitle(
              externalStory.title ?? StringDefault.valueNullDefault),
          const SizedBox(height: 8),
          _buildAuthors(
              externalStory.extendByLine ?? StringDefault.valueNullDefault),
          const SizedBox(height: 16),
          HtmlWidget(
            externalStory.content ?? StringDefault.valueNullDefault,
            customStylesBuilder: (element) {
              if (element.localName == 'a') {
                return {'padding': '0px 0px 0px 0px'};
              }
              return {'padding': '0px 16px 0px 16px'};
            },
          ),
          const SizedBox(height: 16),
          Obx(() {
            final storyAd = controller.rxnStoryAd.value;
            return storyAd != null
                ? MMAdBanner(
                    adUnitId: storyAd.fTUnitId,
                    adSize: AdSize.mediumRectangle,
                    isKeepAlive: true,
                  )
                : const SizedBox.shrink();
          }),
        ]),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: StatefulBuilder(builder: (context, setState) {
              return SizedBox(
                height: AdSize.banner.height.toDouble(),
                width: AdSize.banner.width.toDouble(),
                child: Obx(() {
                  final storyAd = controller.rxnStoryAd.value;
                  return storyAd != null
                      ? MMAdBanner(
                          adUnitId: controller.rxnStoryAd.value!.stUnitId,
                          adSize: AdSize.banner,
                          isKeepAlive: true,
                        )
                      : const SizedBox.shrink();
                }),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(double width, double height, String imageUrl) {
    return CustomCachedNetworkImage(
        height: height, width: width, imageUrl: imageUrl);
  }

  Widget _buildCategory() {
    return Row(
      children: [
        Container(width: 10, height: 20, color: appColor),
        const SizedBox(width: 10),
        Obx(() {
          final section = controller.rxAdMod.value.displayText;
          return Text(
            section,
            style: const TextStyle(fontSize: 20),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryAndPublishedDate(String publishedDate) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategory(),
          Text(
            publishedDate.formattedTaipeiDateTime() ??
                StringDefault.valueNullDefault,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600], /*fontStyle: FontStyle.italic,*/
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Text(
        title,
        style: const TextStyle(fontFamily: 'Open Sans', fontSize: 28),
      ),
    );
  }

  Widget _buildAuthors(String extendByline) {
    // VerticalDivider is broken? so use Container
    var myVerticalDivider = Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        color: Colors.black,
        width: 1,
        height: 16,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(children: [
        Image.asset(
          'assets/image/mm_logo_for_story.png',
          width: 32.0,
          height: 32.0,
        ),
        const SizedBox(width: 12),
        const Text("文"),
        myVerticalDivider,
        Text(extendByline),
      ]),
    );
  }
}
