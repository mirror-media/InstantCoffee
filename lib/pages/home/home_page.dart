import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import 'package:readr_app/widgets/newsMarquee/news_marquee_widget.dart';

import 'widgets/header_bar/header_bar.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderBar(
            controller: controller,
          ),
          Expanded(
            child: Column(
              children: [
                Obx(() {
                  final recordList = controller.rxNewsMarqueeList;
                  return controller.remoteConfigHelper
                              .isNewsMarqueePin &&
                          recordList.isNotEmpty
                      ? Container(
                          color: Colors.white,
                          child: NewsMarqueeWidget(
                            recordList: recordList,
                          ),
                        )
                      : const SizedBox.shrink();
                }),
                Obx(() {
                  final tabContentList = controller.rxTabContentList;
                  return tabContentList.isNotEmpty
                      ? Expanded(
                          child: TabBarView(
                            controller: controller.sectionTabController,
                            children: tabContentList,
                          ),
                        )
                      : const CircularProgressIndicator();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
