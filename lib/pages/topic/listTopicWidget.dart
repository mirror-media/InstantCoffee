import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/controllers/topic/topicPageController.dart';
import 'package:readr_app/helpers/adHelper.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';

class ListTopicWidget extends GetView<TopicPageController> {
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
    return Obx(() {
      if (controller.topicItemList.isEmpty) {
        return const Center(child: Text('無資料'));
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == controller.topicItemList.length) {
            return _loadMoreWidget();
          }

          return _buildListItem(
              context, controller.topicItemList[index].record);
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[300],
          thickness: 1,
          height: 1,
        ),
        itemCount: controller.topicItemList.length + 1,
      );
    });
  }

  Widget _loadMoreWidget() {
    return Obx(() {
      if (controller.isLoadingMore.isFalse && controller.isNoMore.isFalse) {
        controller.fetchMoreTopicItems();
      }

      if (controller.isNoMore.isTrue) {
        return Container();
      }

      return const Center(child: CircularProgressIndicator.adaptive());
    });
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
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
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
                    child: Icon(Icons.error),
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
          RouteGenerator.navigateToStory(record.slug,
              isMemberCheck: record.isMemberCheck);
        }
      },
    );
  }
}
