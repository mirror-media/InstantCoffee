import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/controllers/topic/topic_page_controller.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/models/topic.dart';
import 'package:readr_app/pages/topic/group_topic_widget.dart';
import 'package:readr_app/pages/topic/list_topic_widget.dart';
import 'package:readr_app/pages/topic/portrait_wall_topic_widget.dart';
import 'package:readr_app/pages/topic/slideshow_webview_widget.dart';
import 'package:readr_app/services/topic_service.dart';

class TopicPage extends StatelessWidget {
  final Topic topic;
  const TopicPage(this.topic, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TopicPageController(TopicService(), topic));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: appColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          topic.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: topic.bgColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              if (topic.type != TopicType.slideshow)
                SliverToBoxAdapter(
                  child: Container(
                    color: const Color(0xFFE2E5E7),
                    child: CachedNetworkImage(
                      imageUrl: topic.ogImageUrl,
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
              if (topic.type == TopicType.slideshow)
                SliverToBoxAdapter(
                  child: SlideshowWebviewWidget(topic.id),
                )
            ];
          },
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (topic.type) {
      case TopicType.list:
      case TopicType.slideshow:
        return ListTopicWidget();
      case TopicType.group:
        return GroupTopicWidget();
      case TopicType.portraitWall:
        return PortraitWallTopicWidget();
    }
  }
}
