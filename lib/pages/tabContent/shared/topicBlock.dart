import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/controllers/topic/topicListController.dart';
import 'package:readr_app/helpers/adHelper.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/topic.dart';
import 'package:readr_app/pages/topic/topicListPage.dart';
import 'package:readr_app/pages/topic/topicPage.dart';
import 'package:readr_app/services/topicService.dart';

class TopicBlock extends GetView<TopicListController> {
  final bool isPremium;
  const TopicBlock({this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    Get.put(TopicListController(TopicService()));
    return Obx(
      () {
        if (controller.topicList.isNotEmpty) {
          return _buildTopicBlock(context);
        }
        return Container();
      },
    );
  }

  Widget _buildTopicBlock(BuildContext context) {
    return Container(
      color: Colors.white,
      height: isPremium ? 130 : 138,
      padding: EdgeInsets.only(top: isPremium ? 0 : 24),
      child: Column(
        crossAxisAlignment:
            isPremium ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Container(
            alignment: isPremium ? Alignment.center : Alignment.centerLeft,
            width: double.infinity,
            padding: EdgeInsets.only(
              left: isPremium ? 0 : 16,
              top: isPremium ? 12 : 0,
              bottom: isPremium ? 12 : 0,
            ),
            color: isPremium ? appColor : Colors.white,
            child: Text(
              '熱門專區',
              style: TextStyle(
                fontSize: isPremium ? 16 : 20,
                fontWeight: FontWeight.bold,
                color: isPremium ? Colors.white : appColor,
              ),
            ),
          ),
          Expanded(
            child: _buildList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    List<Topic> topicList = [];
    for (int i = 0; i < controller.topicList.length; i++) {
      topicList.addIf(
          controller.topicList[i].isFeatured, controller.topicList[i]);
      if (topicList.length == 5) {
        break;
      }
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 24),
      itemBuilder: (context, index) {
        if (index == topicList.length) {
          return GestureDetector(
            onTap: () => Get.to(() => TopicListPage()),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                color: Colors.white,
                border: Border.all(
                  color: appColor,
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: const Text(
                '更多',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(0, 0, 0, 0.66),
                ),
              ),
            ),
          );
        }

        return _buildListItem(context, topicList[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemCount: topicList.length + 1,
    );
  }

  Widget _buildListItem(BuildContext context, Topic topic) {
    return GestureDetector(
      onTap: () {
        if (!context.read<MemberBloc>().state.isPremium) {
          AdHelper adHelper = AdHelper();
          adHelper.checkToShowInterstitialAd();
        }
        Get.to(() => TopicPage(topic));
      },
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: Colors.white,
          border: Border.all(
            color: appColor,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(
          '#' + topic.title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(0, 0, 0, 0.66),
          ),
        ),
      ),
    );
  }
}
