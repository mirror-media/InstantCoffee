import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/controllers/topic/topicListController.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/topic.dart';
import 'package:readr_app/widgets/mMAdBanner.dart';

class TopicListPage extends GetView<TopicListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemBuilder: (context, index) {
                    if (index == controller.topicList.length) {
                      return _loadMoreWidget();
                    }
                    return _buildItem(controller.topicList[index]);
                  },
                  separatorBuilder: (context, index) {
                    if (index == 0) {
                      return _buildAdItem(controller.storyAd.aT1UnitId);
                    } else if (index == 4) {
                      return _buildAdItem(controller.storyAd.aT2UnitId);
                    } else if (index == 9) {
                      return _buildAdItem(controller.storyAd.aT3UnitId);
                    }
                    return Divider(
                      thickness: 1,
                      color: Colors.grey,
                    );
                  },
                  itemCount: controller.topicList.length + 1,
                ),
              ),
            ),
            BlocBuilder<MemberBloc, MemberState>(
              builder: (context, state) {
                if (state.status == MemberStatus.loaded && !state.isPremium) {
                  return MMAdBanner(
                    adUnitId: controller.storyAd.stUnitId,
                    adSize: AdSize.banner,
                    isKeepAlive: true,
                  );
                }

                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _loadMoreWidget() {
    return Obx(
      () {
        if (controller.isNoMore.isTrue) {
          return Container();
        }

        if (controller.isLoadingMore.isFalse) {
          controller.fetchMoreTopics();
        }

        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  Widget _buildItem(Topic topic) {
    double width = Get.width;
    double imageSize = 25 * (width - 32) / 100;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    topic.title,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                if (topic.ogImageUrl != null) ...[
                  SizedBox(
                    width: 16,
                  ),
                  CachedNetworkImage(
                    height: imageSize,
                    width: imageSize,
                    imageUrl: topic.ogImageUrl!,
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
              ],
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildAdItem(String adUnitId) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        if (state.status == MemberStatus.loaded && !state.isPremium) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: MMAdBanner(
              adUnitId: adUnitId,
              adSize: AdSize.mediumRectangle,
              isKeepAlive: true,
            ),
          );
        }

        return Divider(
          thickness: 1,
          color: Colors.grey,
        );
      },
    );
  }
}
