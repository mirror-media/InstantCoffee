import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/data/enum/page_status.dart';
import 'package:readr_app/pages/tabContent/podcast_tab_content/podcast_page_controller.dart';
import 'package:readr_app/pages/tabContent/podcast_tab_content/widgets/podcast_info_item.dart';
import 'package:readr_app/pages/tabContent/podcast_tab_content/widgets/podcast_sticky_panel/podcast_sticky_panel.dart';

class PodcastPage extends GetView<PodcastPageController> {
  const PodcastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          final pageStatus = controller.rxPageStatus.value;
          return pageStatus == PageStatus.normal
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Podcast',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 49),
                          Container(
                            height: 30,
                            width: 184,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: Obx(() {
                              final value = controller.rxCurrentAuthor.value;
                              return DropdownButton<String>(
                                isExpanded: true,
                                value: value,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "PingFang TC"),
                                underline: Container(),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                                onChanged: controller.setCurrentAuthor,
                                items: controller.rxAuthorList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "PingFang TC"),
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: Obx(() {
                          final podcastList = controller.rxRenderPodcastList;
                          final selectPodcast =
                              controller.rxnSelectPodcastInfo.value;
                          return ListView.separated(
                            controller: controller.scrollController,
                            itemCount: podcastList.length, // 替換為你的數據長度
                            itemBuilder: (context, index) {
                              return PodcastInfoItem(
                                podcastInfo: podcastList[index],
                                descriptionClick: (description) {
                                  Get.dialog(AlertDialog(
                                    contentPadding: const EdgeInsets.all(20),
                                    content: SizedBox(
                                      height: Get.height * 0.45,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Text(
                                              description ??
                                                  StringDefault
                                                      .valueNullDefault,
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: 'PingFang TC',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                                },
                                isPlaying: selectPodcast == podcastList[index],
                                playClick: () {
                                  controller.podcastInfoSelectEvent(
                                      podcastList[index]);
                                },
                              ); // 替換為你的列表項目
                            },

                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        }),
        AnimatedBuilder(
            animation: controller.animation,
            builder: (BuildContext context, Widget? child) {
              return Positioned(
                bottom: controller.animation.value,
                child: Obx(() {
                  final podcastInfo = controller.rxnSelectPodcastInfo.value;
                  return PodcastStickyPanel(
                    height: 130,
                    width: Get.width,
                    podcastInfo: podcastInfo,
                  );
                }),
              );
            }),
      ],
    );
  }
}
