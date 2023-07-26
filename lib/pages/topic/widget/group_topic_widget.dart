import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';

import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/topic_item.dart';

import '../topic_page_controller.dart';

class GroupTopicWidget extends GetView<TopicPageController> {
  const GroupTopicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    if (controller.topicItemList.isEmpty) {
      return const Center(child: Text('無資料'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == 0 || !_checkPreviousItemTagSame(index)) {
          return _buildItemWithTag(context, controller.topicItemList[index]);
        }

        return _buildListItem(context, controller.topicItemList[index].record);
      },
      separatorBuilder: (context, index) {
        if (!_checkPreviousItemTagSame(index + 1)) {
          return Container();
        }
        return Divider(
          color: controller.topic.dividerColor,
          thickness: 1,
          height: 1,
        );
      },
      itemCount: controller.topicItemList.length,
    );
  }

  bool _checkPreviousItemTagSame(int currentIndex) {
    if (currentIndex > 0 && currentIndex < controller.topicItemList.length) {
      if (controller.topicItemList[currentIndex].tagId ==
          controller.topicItemList[currentIndex - 1].tagId) {
        return true;
      }
    }
    return false;
  }

  Widget _buildItemWithTag(BuildContext context, TopicItem topicItem) {
    if (topicItem.tagTitle != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            topicItem.tagTitle!,
            style: TextStyle(
              fontSize: 26,
              color: controller.topic.subTitleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          _buildListItem(context, topicItem.record),
        ],
      );
    }

    return _buildListItem(context, topicItem.record);
  }

  Widget _buildListItem(BuildContext context, Record record) {
    double width = Get.width;
    double imageSize = 25 * (width - 48) / 100;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    record.title,
                    style: TextStyle(
                      fontSize: 20,
                      color: controller.topic.recordTitleColor,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                CachedNetworkImage(
                  height: imageSize,
                  width: imageSize,
                  imageUrl: record.photoUrl,
                  placeholder: (context, url) => Container(
                    height: imageSize,
                    width: imageSize,
                    color: Colors.grey,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: imageSize,
                    width: imageSize,
                    color: Colors.grey,
                    child: const Icon(Icons.error),
                  ),
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (!context.read<MemberBloc>().state.isPremium) {
          AdHelper adHelper = AdHelper();
          adHelper.checkToShowInterstitialAd();
        }

        if (record.isExternal) {
          RouteGenerator.navigateToExternalStory(record.slug);
        } else {
          RouteGenerator.navigateToStory(
            record.slug,
            isMemberCheck: record.isMemberCheck,
            url: record.url,
          );
        }
      },
    );
  }
}
