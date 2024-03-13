import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/pages/tab_content/tab_content_controller.dart';
import 'package:readr_app/pages/tab_content/widgets/list_article_item.dart';
import 'package:readr_app/widgets/m_m_ad_banner.dart';

class TabContentPage extends StatelessWidget {
  const TabContentPage({Key? key, required this.slug, this.isPremium = false})
      : super(key: key);
  final String slug;
  final bool? isPremium;

  @override
  Widget build(BuildContext context) {
    final TabContentController controller = Get.find(tag: slug);

    return RefreshIndicator(
      onRefresh: () async {},
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (slug == 'member')
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 37.5),
                      child: Image.asset(subscribeBannerJpg),
                    ),
                    onTap: () => RouteGenerator.navigateToSubscriptionSelect(),
                  ),
                Obx(() {
                  final sectionAd = controller.rxnSectionAd.value;
                  return sectionAd != null
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 16.0,
                            ),
                            // carouselAT1AdIndex
                            Center(
                              child: MMAdBanner(
                                adUnitId: sectionAd.aT1UnitId,
                                adSize: AdSize.mediumRectangle,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                }),
                const SizedBox(
                  height: 16.0,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: Text(
                    '最新文章',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: appColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Obx(() {
                  final recordList = controller.rxRecordList;

                  return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () => controller
                                .navigateToStoryPage(recordList[index]),
                            child: ListArticleItem(record: recordList[index]));
                      },
                      separatorBuilder: (context, index) {
                        if (index == noCarouselAT2AdIndex) {
                          return Obx(() {
                            final sectionAd = controller.rxnSectionAd.value;
                            return sectionAd != null
                                ? MMAdBanner(
                                    adUnitId: sectionAd.aT2UnitId,
                                    adSize: AdSize.mediumRectangle,
                                  )
                                : const SizedBox.shrink();
                          });
                        }
                        if (index == noCarouselAT3AdIndex) {
                          return Obx(() {
                            final sectionAd = controller.rxnSectionAd.value;
                            return sectionAd != null
                                ? MMAdBanner(
                                    adUnitId: sectionAd.aT3UnitId,
                                    adSize: AdSize.mediumRectangle,
                                  )
                                : const SizedBox.shrink();
                          });
                        }

                        return const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        );
                      },
                      itemCount: recordList.length);
                }),
                const SizedBox(height: 300),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Obx(() {
                final sectionAd = controller.rxnSectionAd.value;
                return StatefulBuilder(builder: (context, setState) {
                  return isTabContentAdsActivated && sectionAd != null
                      ? SizedBox(
                          height: AdSize.banner.height.toDouble(),
                          width: AdSize.banner.width.toDouble(),
                          child: MMAdBanner(
                            adUnitId: sectionAd!.stUnitId,
                            adSize: AdSize.banner,
                            isKeepAlive: true,
                          ),
                        )
                      : const SizedBox.shrink();
                });
              }),
            ),
          ),
        ],
      ),
    );
  }
}
