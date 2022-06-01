import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/controllers/topic/topicPageController.dart';
import 'package:readr_app/helpers/adHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/topicImageItem.dart';

class PortraitWallTopicWidget extends GetView<TopicPageController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopicPageController>(
      builder: (controller) {
        if (controller.isError) {
          return const Center(
            child: Text('發生錯誤，請稍後再試'),
          );
        }

        if (!controller.isLoading) {
          return _buildList(context);
        }

        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  Widget _buildList(BuildContext context) {
    if (controller.portraitWallItemList.isEmpty) {
      return const Center(child: Text('無資料'));
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 31.5,
        crossAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) =>
          _buildItem(context, controller.portraitWallItemList[index]),
      itemCount: controller.portraitWallItemList.length,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
    );
  }

  Widget _buildItem(BuildContext context, TopicImageItem topicImageItem) {
    double imageSize = (Get.width - 96 - 24) / 2;
    return InkWell(
      onTap: () {
        if (topicImageItem.record != null) {
          if (!context.read<MemberBloc>().state.isPremium) {
            AdHelper adHelper = AdHelper();
            adHelper.checkToShowInterstitialAd();
          }

          if (topicImageItem.record!.isExternal) {
            RouteGenerator.navigateToExternalStory(topicImageItem.record!.slug);
          } else {
            RouteGenerator.navigateToStory(
              topicImageItem.record!.slug,
              isMemberCheck: topicImageItem.record!.isMemberCheck,
              url: topicImageItem.record!.url,
            );
          }
        }
      },
      child: Column(
        children: [
          CachedNetworkImage(
            height: imageSize,
            width: imageSize,
            imageUrl: topicImageItem.imageUrl,
            placeholder: (context, url) => Container(
              height: imageSize,
              width: imageSize,
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Container(
              height: imageSize,
              width: imageSize,
              color: Colors.grey,
              child: Icon(Icons.error),
            ),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          Text(
            topicImageItem.description,
            style: TextStyle(
              fontSize: 20,
              color: controller.topic.recordTitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
