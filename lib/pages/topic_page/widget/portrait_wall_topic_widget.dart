import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/topic_image_item.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';

import '../topic_page_controller.dart';

class PortraitWallTopicWidget extends GetView<TopicPageController> {
  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    if (controller.portraitWallItemList.isEmpty) {
      return const Center(child: Text('無資料'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          if (!context.read<MemberBloc>().state.shouldShowPremiumUI) {
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
          CustomCachedNetworkImage(
              height: imageSize,
              width: imageSize,
              imageUrl: topicImageItem.imageUrl),
          const SizedBox(height: 12),
          Text(
            topicImageItem.description,
            style: TextStyle(
              fontSize: 20,
              color: controller.rxCurrentTopic.value?.recordTitleColor,
            ),
          ),
        ],
      ),
    );
  }
}
