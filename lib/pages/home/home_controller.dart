import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/data/enum/header_type.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/data/providers/auth_provider.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/models/header/header.dart';
import 'package:readr_app/models/header/header_category.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/pages/latest_page/latest_page.dart';
import 'package:readr_app/pages/tabContent/personal/default/personal_tab_content.dart';
import 'package:readr_app/pages/tabContent/podcast_tab_content/podcast_page.dart';
import 'package:readr_app/pages/tab_content/tab_content_controller.dart';
import 'package:readr_app/pages/tab_content/tab_content_page.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final RxList<Record> rxNewsMarqueeList = RxList();
  final ArticlesApiProvider _articlesApiProvider = Get.find();
  final AuthProvider authProvider = Get.find();
  final RxList<Header> rxHeaderList = RxList();
  final RxList<Widget> rxTabContentList = RxList();
  final RxList<HeaderCategory> rxCategoryList = RxList();
  final Rxn<Header> rxCurrentHeader = Rxn();
  final Rxn<HeaderCategory> rxCurrentCategory = Rxn();
  late TabController sectionTabController;
  late TabController categoryTabController;
  late AnimationController animationController;
  late Animation<double> _animation;
  final RxDouble rxAppBarHeight = 0.0.obs;
  final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();

  Worker? categoryWorker;

  dynamic arg;

  final Map<String, Widget> specialTabWidgetMap = {
    'Podcasts': const PodcastPage(),
    'personal': const PersonalTabContent(),
    'latest': const LatestPage(),
  };

  HomeController(this.arg);

  @override
  void onReady() {
    if (arg != null && arg['tab'] != null) {
      final key = arg['tab'];
      if (key == 'bookmark') {
        Timer(const Duration(seconds: 1), gotoBookmark);
      } else if (key == 'premium') {
        Timer(const Duration(seconds: 1), gotoPremium);
      }
    }
  }

  void headerInit() async {
    final headerList = await _articlesApiProvider.getAppBarHeaders();
    String jsonFixed =
        await rootBundle.loadString('assets/data/default_header_section.json');
    final fixedHeaderList = json.decode(jsonFixed) as List<dynamic>;
    final fixedHeader = fixedHeaderList.map((e) => Header.fromJson(e)).toList();
    fixedHeader.addAll(headerList);

    int indexToMove =
        fixedHeader.indexWhere((section) => section.name == 'Podcasts');

    // 找到 '生活' 的 Section
    int indexAfter = fixedHeader.indexWhere((section) => section.name == '生活');

    // 如果找到了 'podcast' 和 '生活'，而且 'podcast' 在 '生活' 之前
    if (indexToMove != -1 && indexAfter != -1 && indexToMove < indexAfter) {
      // 取出 'podcast'
      Header headerToMove = fixedHeader.removeAt(indexToMove);
      // 插入到 '生活' 的後面
      fixedHeader.insert(indexAfter, headerToMove);
    }
    rxHeaderList.value = fixedHeader;

    for (var header in rxHeaderList) {
      Get.lazyPut(() => TabContentController(header), tag: header.slug);
      if (specialTabWidgetMap.containsKey(header.slug)) {
        rxTabContentList.add(specialTabWidgetMap[header.slug]!);
      } else {
        rxTabContentList.add(TabContentPage(
            slug: header.slug ?? StringDefault.valueNullDefault));
      }
    }

    sectionTabController =
        TabController(length: rxHeaderList.length, vsync: this);
    sectionTabController.addListener(sectionTabControllerChangeEvent);
    sectionTabControllerChangeEvent();
  }

  @override
  void onInit() async {
    super.onInit();

    categoryTabController = TabController(length: 0, vsync: this);
    sectionTabController = TabController(length: 0, vsync: this);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 28).animate(animationController)
      ..addListener(() {
        rxAppBarHeight.value = _animation.value;
      });

    rxNewsMarqueeList.value = await _articlesApiProvider.getNewsletterList();

    headerInit();

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

  void sectionTabControllerChangeEvent() {
    rxCurrentHeader.value = rxHeaderList[sectionTabController.index];

    if (rxCurrentHeader.value?.type == HeaderType.section) {
      rxCategoryList.value = rxCurrentHeader.value?.categories ?? [];
    } else {
      rxCategoryList.value = [];
    }

    categoryTabController =
        TabController(length: rxCategoryList.length, vsync: this);
    categoryTabController.removeListener(categoryTabControllerChangeEvent);
    categoryTabController.addListener(categoryTabControllerChangeEvent);
  }

  void categoryTabControllerChangeEvent() {
    rxCurrentCategory.value = rxCategoryList[categoryTabController.index];
  }

  void gotoBookmark() {
    sectionTabController.animateTo(2);
  }

  void gotoPremium() {
    sectionTabController.animateTo(3);
  }

  @override
  void dispose() {
    categoryWorker?.dispose();
  }
}
