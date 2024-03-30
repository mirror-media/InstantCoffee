import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/core/values/image_path.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/article_page/article_controller.dart';
import 'package:readr_app/pages/article_page/widgets/article_info_panel.dart';
import 'package:readr_app/pages/article_page/widgets/donate_block.dart';
import 'package:readr_app/routes/routes.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/paragraph_widget_factory.dart';

class ArticlePage extends GetView<ArticleController> {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPremium = controller.rxIsPremium.value;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: isPremium ? Colors.black : appColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(id: Routes.navigationKey),
          ),
          title: Obx(() {
            final section = controller.rxnStory.value?.getSectionTitle();
            return Text(section ?? StringDefault.valueNullDefault);
          }),
        ),
        body: Obx(() {
          final story = controller.rxnStory.value;
          return story != null
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(() {
                        final isPremium = controller.authProvider.rxnMemberInfo
                                .value?.isPremiumMember ??
                            false;
                        return isPremium
                            ? const SizedBox.shrink()
                            : const SizedBox(
                                height: 20,
                              );
                      }),
                      Obx(() {
                        final imageUrl = controller.rxnStory.value?.heroImage;
                        final isPremium = controller.rxIsPremium.value;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isPremium ? 0 : 28),
                          child: CustomCachedNetworkImage(
                              width: double.infinity, imageUrl: imageUrl!),
                        );
                      }),
                      const SizedBox(height: 20),
                      Obx(() {
                        final isPremium = controller.rxIsPremium.value;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isPremium ? 20 : 48),
                          child: Obx(() {
                            final title = controller.rxnStory.value?.title;
                            return Column(
                              children: [
                                Text(
                                  title ?? StringDefault.valueNullDefault,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }),
                        );
                      }),
                      Obx(() {
                        final isPremium = controller.rxIsPremium.value;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isPremium ? 0 : 28),
                          child: Obx(() {
                            final subTitle =
                                controller.rxnStory.value?.subtitle;
                            return subTitle != null && subTitle != ""
                                ? Column(
                                    children: [
                                      Text(
                                        subTitle,
                                        style: const TextStyle(
                                            color: Color(0xFF717171),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 28,
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 10,
                                  );
                          }),
                        );
                      }),
                      Obx(() {
                        final story = controller.rxnStory.value;
                        final isExternal = controller.rxIsExternal.value;
                        return story != null
                            ? ArticleInfoPanel(
                                storySource: story,
                                isPremium: isPremium,
                                isExternal: isExternal)
                            : const SizedBox.shrink();
                      }),
                      Padding(
                        padding: EdgeInsets.all(isPremium ? 20 : 28),
                        child: Obx(() {
                          final articleBrief = controller.rxnStory.value?.brief;
                          final sectionName =
                              controller.rxnStory.value?.getSectionName();
                          return articleBrief != null &&
                                  articleBrief.isNotEmpty &&
                                  articleBrief[0].contents[0].data!.length > 1
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: sectionColorMaps
                                            .containsKey(sectionName)
                                        ? Color(sectionColorMaps[sectionName]!)
                                        : appColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  child: Text(
                                    articleBrief[0].contents[0].data ?? '',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        height: 2,
                                        fontSize: 18,
                                        letterSpacing: 1),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }),
                      ),
                      Obx(() {
                        final paragraphList = controller.rxRenderParagraphList;
                        final isTrimmed = controller.rxIsTrimmed.value;

                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: paragraphList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Wrap(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    ParagraphWidgetFactory.create(
                                        paragraphList[index]),
                                    isTrimmed&& index == paragraphList.length-1? Container(
                                      alignment: Alignment.bottomCenter,
                                        width: double.infinity,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0),
                                              Colors.white
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        )):const SizedBox.shrink()
                                  ],
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            if (isTrimmed &&
                                index == paragraphList.length - 1) {
                              return Container(
                                  width: 100,
                                  height: 100,
                                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red.withOpacity(1),
                                        Colors.white
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ));
                            }
                            return const SizedBox(height: 20);
                          },
                        );
                      }),
                      Obx(() {
                        final isPremium = controller.rxIsPremium.value;
                        return isPremium
                            ? SizedBox(
                                width: 300,
                                child: Obx(() {
                                  final storyTags =
                                      controller.rxnStory.value?.tags ?? [];
                                  return Wrap(
                                    children: storyTags.map((e) {
                                      return Wrap(
                                        children: [
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: appDeepBlue,
                                                border: Border.all(
                                                    color: appDeepBlue,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(2.0),
                                                ),
                                              ),
                                              child: Text(
                                                e.name,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                }),
                              )
                            : const SizedBox.shrink();
                      }),
                      const SizedBox(height: 12),
                      Obx(() {
                        final memberMemberLevel =
                            controller.rxMemberLevel.value;
                        return DonateBlock(memberLevel: memberMemberLevel);
                      }),
                      const SizedBox(height: 24),
                      Obx(() {
                        final relateRecordList = controller.rxRelateRecordList;
                        return relateRecordList.isNotEmpty
                            ? const Text(
                                '延伸閱讀',
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.w600),
                              )
                            : const SizedBox.shrink();
                      }),
                      Wrap(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(38, 20, 38, 0),
                          child: Obx(() {
                            final isPremium = controller.rxIsPremium.value;
                            return Container(
                              color: isPremium
                                  ? Colors.transparent
                                  : const Color(0xFFEEEEEE),
                              padding: const EdgeInsets.fromLTRB(10, 28, 10, 0),
                              child: Obx(() {
                                final relateRecordList =
                                    controller.rxRelateRecordList;
                                return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          CachedNetworkImage(
                                              imageUrl: relateRecordList[index]
                                                  .photoUrl),
                                          const SizedBox(height: 8),
                                          Text(
                                            relateRecordList[index].title ?? '',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 20);
                                    },
                                    itemCount: relateRecordList.length);
                              }),
                            );
                          }),
                        ),
                      ]),
                      SizedBox(
                        height: Get.height * 0.25,
                      )
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        }),
      );
    });
  }
}
