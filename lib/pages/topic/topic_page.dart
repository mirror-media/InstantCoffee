import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/string.dart';

import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/topic/topic_page_controller.dart';
import 'package:readr_app/pages/topic/widget/group_topic_widget.dart';
import 'package:readr_app/pages/topic/widget/list_topic_widget.dart';
import 'package:readr_app/pages/topic/widget/portrait_wall_topic_widget.dart';
import 'package:readr_app/pages/topic/widget/slideshow_webview_widget.dart';

import '../../data/enum/topic_page_status.dart';
import '../../data/enum/topic_type.dart';

class TopicPage extends GetView<TopicPageController> {
  const TopicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: appColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Obx(() {
          final title = controller.rxCurrentTopic.value?.title ??
              StringDefault.valueNullDefault;
          return Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          );
        }),
      ),
      backgroundColor: controller.topic.bgColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              if (controller.topic.type != TopicType.slideshow)
                SliverToBoxAdapter(
                  child: Container(
                    color: const Color(0xFFE2E5E7),
                    child: CachedNetworkImage(
                      imageUrl: controller.topic.ogImageUrl,
                      fit: BoxFit.contain,
                      width: Get.width,
                      height: Get.width / (16 / 9),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      errorWidget: (context, url, error) => Container(),
                    ),
                  ),
                ),
              if (controller.topic.type == TopicType.slideshow)
                Obx(() {
                  final topic = controller.rxCurrentTopic.value;
                  if (topic == null ||
                      topic.id == null ||
                      topic.type != TopicType.slideshow) {
                    return const SizedBox.shrink();
                  }
                  return SliverToBoxAdapter(
                    child: SlideshowWebviewWidget(topic.id!),
                  );
                })
            ];
          },
          body: Obx(() {
            final pageStatus = controller.rxPageStatus.value;
            switch (pageStatus) {
              case TopicPageStatus.normal:
                return _buildBody();
              case TopicPageStatus.error:
                return const Center(
                  child: Text('發生錯誤，請稍後再試'),
                );
              case TopicPageStatus.loading:
                return const Center(
                    child: CircularProgressIndicator.adaptive());
            }
          }),
        ),
      ),
    );
  }

  Widget _buildBody() {
      final topicType =controller.rxCurrentTopic.value?.type;
      switch (topicType) {
        case TopicType.list:
        case TopicType.slideshow:
          return ListTopicWidget(controller: controller,);
        case TopicType.group:
          return GroupTopicWidget();
        case TopicType.portraitWall:
          return PortraitWallTopicWidget();
        default:
          return const SizedBox.shrink();
      }
  }
}
