import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/core/values/image_path.dart';
import 'package:readr_app/pages/home/home_controller.dart';

import 'widgets/triangle_tab_indicator.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    Key? key,

    required this.controller,
  }) : super(key: key);

  final HomeController controller;



  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Obx(() {
          final isPremium =
              controller.authProvider.rxnMemberInfo.value?.isPremiumMember;
          return Container(
            height: 56,
            color: isPremium==true ? appBarPremiumColor : appColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isPremium == true) ...[
                  Image.asset(
                    ImagePath.mirrorMediaLogo,
                    width: 62,
                    height: 26,
                  ),
                ],
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Obx(() {
                          final headerList = controller.rxHeaderList;
                          return TabBar(
                            tabAlignment: TabAlignment.start,
                            controller: controller.sectionTabController,
                            dividerColor: Colors.transparent,
                            unselectedLabelColor: isPremium == true
                                ? appBarPremiumTextColor
                                : appBarNormalTextColor,
                            labelColor: isPremium == true
                                ? appBarPremiumSelectTextColor
                                : appBarNormalSelectTextColor,
                            indicator:
                                const TriangleTabIndicator(color: Colors.white),
                            isScrollable: true,
                            tabs: headerList
                                .map((element) => Tab(
                                    text: element.name == "會員專區"
                                        ? 'Premium文章'
                                        : element.name))
                                .toList(),
                          );
                        })),
                  ),
                ),
              ],
            ),
          );
        }),
        Obx(() {
          final isPremium =
              controller.authProvider.rxnMemberInfo.value?.isPremiumMember;
          final barHeight =controller.rxAppBarHeight.value;
          return Container(
            color: isPremium == true
                ? appBarCategoryPremiumColor
                : appBarCategoryColor,
            height: barHeight,
            child: Obx(() {
              final categoryList = controller.rxCategoryList;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                    tabAlignment: TabAlignment.start,
                    controller: controller.categoryTabController,
                    isScrollable: true,
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    unselectedLabelColor: isPremium==true
                        ? appBarCategoryPremiumTextColor
                        : appBarCategoryTextColor,
                    labelColor: isPremium == true
                        ? appBarCategoryPremiumSelectColor
                        : appBarCategorySelectColor,
                    tabs: categoryList
                        .map((element) => Tab(text: element.name))
                        .toList()),
              );
            }),
          );
        })
      ],
    );

  }
}
