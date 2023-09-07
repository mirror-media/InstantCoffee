import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/topic_page/topic_page_controller.dart';
import 'package:readr_app/pages/topic_page/widget/list_topic_widget.dart';
import 'package:readr_app/pages/topic_page/widget/portrait_wall_topic_widget.dart';
import 'package:readr_app/pages/topic_page/widget/slideshow_webview_widget.dart';
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
          final title = controller.rxCurrentTopic.value?.name ??
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
      backgroundColor: controller.rxCurrentTopic.value?.bgColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              controller.rxCurrentTopic.value?.type != TopicType.slideshow
                  ? SliverToBoxAdapter(
                      child: Container(
                        color: const Color(0xFFE2E5E7),
                        child: CachedNetworkImage(
                          imageUrl: controller.rxCurrentTopic.value
                                  ?.originImage!.imageCollection!.w800 ??
                              '',
                          fit: BoxFit.contain,
                          width: Get.width,
                          height: Get.width / (16 / 9),
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          errorWidget: (context, url, error) => Container(),
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(
                    child: SlideshowWebViewWidget(
                        controller.rxCurrentTopic.value?.slug ??
                            StringDefault.valueNullDefault),
                  ),
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
    final topicType = controller.rxCurrentTopic.value?.type;
    switch (topicType) {
      case TopicType.list:
      case TopicType.slideshow:
      case TopicType.group:
        return ListTopicWidget(controller: controller);
      case TopicType.portraitWall:
        return PortraitWallTopicWidget();
      default:
        return const SizedBox.shrink();
    }
  }
}
