import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import '../../../helpers/route_generator.dart';
import '../../../models/topic/topic_model.dart';
import '../../top_list_page/topic_list_binding.dart';
import '../../top_list_page/topic_list_page.dart';


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
              onTap: () =>
                  Get.to(const TopicListPage(), binding: TopicListBinding()),
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


        RouteGenerator.routerToTopicPage(topic: topic);
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
