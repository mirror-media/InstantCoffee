import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/controllers/topic/topicPageController.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/topic.dart';
import 'package:readr_app/pages/topic/groupTopicWidget.dart';
import 'package:readr_app/pages/topic/listTopicWidget.dart';
import 'package:readr_app/pages/topic/portraitWallTopicWidget.dart';
import 'package:readr_app/pages/topic/slideshowCarouselWidget.dart';
import 'package:readr_app/services/topicService.dart';

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
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
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
              if (topic.ogImageUrl != null && topic.type != TopicType.slideshow)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.black,
                    child: CachedNetworkImage(
                      imageUrl: topic.ogImageUrl!,
                      fit: BoxFit.contain,
                      width: Get.width,
                      height: Get.width / (16 / 9),
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      errorWidget: (context, url, error) => Container(),
                    ),
                  ),
                ),
              if (topic.type == TopicType.slideshow)
                SliverToBoxAdapter(
                  child: SlideshowCarouselWidget(topic),
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
