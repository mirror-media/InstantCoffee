import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import 'package:readr_app/pages/topic/topic_page_binding.dart';
import 'package:readr_app/pages/topic/top_list_page/topic_list_page.dart';
import 'package:readr_app/pages/topic/topic_page.dart';

import '../../../models/topic/topic_model.dart';

class TopicBlock extends StatelessWidget {
  final bool isPremium;
  final HomeController controller = Get.find();

  TopicBlock({Key? key, this.isPremium = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildTopicBlock(context);
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
    return Obx(() {
      final topicList = controller.rxTopicList;
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
    });
  }

  Widget _buildListItem(BuildContext context, TopicModel topic) {
    return GestureDetector(
      onTap: () {
        if (!context.read<MemberBloc>().state.isPremium) {
          AdHelper adHelper = AdHelper();
          adHelper.checkToShowInterstitialAd();
        }

        ///  Todo 因目前專案沒有routers管理 直接在這邊寫入binding 後續需要統一routers管理
        Get.to(() => const TopicPage(),
            binding: TopicPageBinding(), arguments: {'topic': topic});
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
          '#${topic.name}',
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
