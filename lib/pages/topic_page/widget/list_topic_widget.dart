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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    post.title ?? StringDefault.valueNullDefault,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                CustomCachedNetworkImage(
                    height: imageSize,
                    width: imageSize,
                    imageUrl: post.heroImage?.imageCollection?.original ?? ''),
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
    );
  }
}
