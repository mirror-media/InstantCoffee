import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/models/header/header.dart';
import 'package:readr_app/models/header/header_category.dart';
import 'package:readr_app/pages/tabContent/personal/default/personal_tab_content.dart';
import 'package:readr_app/pages/tabContent/podcast_tab_content/podcast_page.dart';

class HeaderBarController extends GetxController
    with GetTickerProviderStateMixin {
  final RxList<Header> rxHeaderList = RxList();
  final RxList<HeaderCategory> rxCategoryList = RxList();
  late AnimationController animationController;
  late Animation<double> _animation;
  final RxDouble rxAppBarHeight = 0.0.obs;

  final Rxn<HeaderCategory> rxCurrentCategory = Rxn();
  late Worker? categoryWorker;
  final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
  late TabController categoryTabController;
  final Map<String, Widget> specialTabWidgetMap = {
    'Podcasts': const PodcastPage(),
    'personal': const PersonalTabContent(),
  };

  @override
  void onInit() async {
    super.onInit();
    categoryTabController = TabController(length: 0, vsync: this);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 28).animate(animationController)
      ..addListener(() {
        rxAppBarHeight.value = _animation.value;
      });
    categoryWorker = ever<List<HeaderCategory>>(rxCategoryList, (categoryList) {
      if (categoryList.isEmpty &&
          animationController.status == AnimationStatus.completed) {
        animationController.reverse();
        return;
      }
      if (categoryList.isNotEmpty &&
          animationController.status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
  }

  void setCategoryList(List<HeaderCategory> categoryList) {
    rxCategoryList.value = categoryList;
    categoryTabController =
        TabController(length: rxCategoryList.length, vsync: this);
    categoryTabController.removeListener(categoryTabControllerChangeEvent);
    categoryTabController.addListener(categoryTabControllerChangeEvent);
  }

  void categoryTabControllerChangeEvent() {
    rxCurrentCategory.value = rxCategoryList[categoryTabController.index];
  }

  @override
  void onClose() {}
}
