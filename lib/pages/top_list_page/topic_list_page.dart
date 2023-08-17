import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/widgets/m_m_ad_banner.dart';

import '../../helpers/route_generator.dart';
import '../../models/topic/topic_model.dart';
import 'topic_list_controller.dart';

class TopicListPage extends GetView<TopicListController> {
  const TopicListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        title: const Text('Topic List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                final topicList = controller.rxTopicList;
                return topicList.isEmpty
                    ? const Center(child: Text('無資料'))
                    : ListView.separated(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemBuilder: (context, index) {
                          if (index == topicList.length) {
                            Obx(() {
                              final isEnd = controller.rxIsEnd.value;
                              return isEnd
                                  ? const SizedBox.shrink()
                                  : const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                            });
                          }
                          if (index == 0) {
                            return _buildFirstItem(context, topicList[index]);
                          }

                          return _buildItem(context, topicList[index]);
                        },
                        separatorBuilder: (context, index) {
                          return Obx(() {
                            final storyAd = controller.rxStoryAd.value;
                            if (index == 0 && storyAd != null) {
                              return _buildAdItem(storyAd.aT1UnitId);
                            } else if (index == 5 && storyAd != null) {
                              return _buildAdItem(storyAd.aT2UnitId);
                            } else if (index == 10 && storyAd != null) {
                              return _buildAdItem(storyAd.aT3UnitId);
                            }
                            return const Divider(
                              thickness: 1,
                              color: Colors.grey,
                            );
                          });
                        },
                        itemCount: topicList.length,
                      );
              },
            ),
          ),
          BlocBuilder<MemberBloc, MemberState>(
            builder: (context, state) {
              if (state.status == MemberStatus.loaded && !state.isPremium) {
                return Obx(() {
                  final storyAd = controller.rxStoryAd.value;
                  return storyAd != null
                      ? MMAdBanner(
                          adUnitId: storyAd.stUnitId,
                          adSize: AdSize.banner,
                          isKeepAlive: true,
                        )
                      : const SizedBox.shrink();
                });
              }

              return Container();
            },
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, TopicModel topic) {
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
                    topic.name ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                CachedNetworkImage(
                  height: imageSize,
                  width: imageSize,
                  imageUrl: topic.originImage?.imageCollection?.w800 ?? '',
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
        RouteGenerator.routerToTopicPage(topic: topic);
      },
    );
  }

  Widget _buildAdItem(String adUnitId) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        if (state.status == MemberStatus.loaded && !state.isPremium) {
          return Column(
            children: [
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: MMAdBanner(
                  adUnitId: adUnitId,
                  adSize: AdSize.mediumRectangle,
                  isKeepAlive: true,
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ],
          );
        }

        return const Divider(
          thickness: 1,
          color: Colors.grey,
        );
      },
    );
  }

  Widget _buildFirstItem(BuildContext context, TopicModel topic) {
    double width = Get.width;

    return InkWell(
      child: Column(
        children: [
          CachedNetworkImage(
            height: width / 16 * 9,
            width: width,
            imageUrl: topic.originImage?.imageCollection?.w800 ?? '',
            placeholder: (context, url) => Container(
              height: width / 16 * 9,
              width: width,
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Container(
              height: width / 16 * 9,
              width: width,
              color: Colors.grey,
              child: const Icon(Icons.error),
            ),
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Text(
              topic.name ?? '',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      onTap: () {
        if (!context.read<MemberBloc>().state.isPremium) {
          AdHelper adHelper = AdHelper();
          adHelper.checkToShowInterstitialAd();
        }
        RouteGenerator.routerToTopicPage(topic: topic);
      },
    );
  }
}
