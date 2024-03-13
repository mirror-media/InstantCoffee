import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/latest_page/latest_page_controller.dart';
import 'package:readr_app/pages/tabContent/news/widget/live_stream_widget.dart';
import 'package:readr_app/pages/tabContent/shared/topic_block.dart';
import 'package:readr_app/pages/tab_content/widgets/list_article_item.dart';
import 'package:readr_app/widgets/editor_choice_carousel.dart';
import 'package:readr_app/widgets/m_m_ad_banner.dart';

class LatestPage extends GetView<LatestPageController> {
  const LatestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LatestPageController>()) {
      Get.put(LatestPageController());
    }

    return Stack(
      children: [
        SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: [
              Obx(() {
                final choiceRecordList = controller.rxEditorChoiceList.value;
                return EditorChoiceCarousel(
                  editorChoiceList: choiceRecordList,
                  aspectRatio: 16 / 10,
                );
              }),
              Column(
                children: [
                  TopicBlock(),
                  const SizedBox(height: 24),
                  Obx(() {
                    final liveStreamModel = controller.rxLiveStreamModel.value;
                    final ytController = controller.ytStreamController;
                    return liveStreamModel != null
                        ? LiveStreamWidget(
                            title: liveStreamModel.name ??
                                StringDefault.valueNullDefault,
                            ytPlayer: ytController,
                          )
                        : Container();
                  }),
                  const SizedBox(
                    height: 16.0,
                  ),
                ],
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
                final recordList = controller.rxRenderRecordList.value;
                return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () =>
                              controller.navigateToStoryPage(recordList[index]),
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
              const SizedBox(
                height: 300,
              ),
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
    );
  }
}
