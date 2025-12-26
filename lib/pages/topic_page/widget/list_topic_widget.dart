import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';

import '../../../models/post/post_model.dart';
import '../../../widgets/custom_cached_network_image.dart';
import '../topic_page_controller.dart';

class ListTopicWidget extends StatelessWidget {
  const ListTopicWidget({Key? key, required this.controller}) : super(key: key);
  final TopicPageController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<PostModel> postList = controller.rxRelatedPostList;
      return postList.isEmpty
          ? const Center(child: Text('無資料'))
          : ListView.separated(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == postList.length) {
            Obx(() {
              final isEnd = controller.rxIsEnd.value;
              return isEnd
                  ? const SizedBox.shrink()
                  : const Center(
                  child: CircularProgressIndicator.adaptive());
            });
          }

          return _buildListItem(context, postList[index]);
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[300],
          thickness: 1,
          height: 1,
        ),
        itemCount: postList.length,
      );
    });
  }

  Widget _buildListItem(BuildContext context, PostModel post) {
    double width = Get.width;
    double imageSize = 25 * (width - 48) / 100;

    return InkWell(
      onTap: () {
        if (!context.read<MemberBloc>().state.shouldShowPremiumUI) {
          AdHelper adHelper = AdHelper();
          adHelper.checkToShowInterstitialAd();
        }

        if (post.isExternal && post.slug != null) {
          RouteGenerator.navigateToExternalStory(post.slug!);
        } else {
          RouteGenerator.navigateToStory(
            post.slug ?? '',
            isMemberCheck: post.isMember ?? false,
            url: post.getUrl,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- 標題與圖片區塊 ----
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    post.title ?? StringDefault.valueNullDefault,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                CustomCachedNetworkImage(
                  height: imageSize,
                  width: imageSize,
                  imageUrl: post.heroImage?.imageCollection?.original ?? '',
                ),
              ],
            ),

            // ---- 推到底部的空間 ----
            const SizedBox(height: 1),

            // ---- 發佈時間 ----
            if (post.publishedDate != null)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _formatDate(post.publishedDate!),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
    } catch (e) {
      return '';
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
