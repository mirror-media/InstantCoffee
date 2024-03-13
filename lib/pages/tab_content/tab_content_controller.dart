import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/data/enum/header_type.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/header/header.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section_ad.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import 'package:readr_app/pages/home/widgets/header_bar/header_bar_controller.dart';

import '../../models/header/header_category.dart';

class TabContentController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final Rxn<SectionAd> rxnSectionAd = Rxn();
  final RxList<Record> rxRecordList = RxList();
  final ArticlesApiProvider articlesApiProvider = Get.find();
  final Rxn<Header> rxCurrentHeader = Rxn();
  final Rxn<HeaderCategory> rxnHeaderCategory = Rxn();
  late HeaderType currentType = HeaderType.section;
  int page = 1;

  TabContentController(Header? header) {
    rxCurrentHeader.value = header;
  }

  final HomeController homeController = Get.find();
  final HeaderBarController headerBarController = Get.find();
  Worker? sectionWorker;
  Worker? categoryWorker;

  void headerUpdateEvent(Header? header) {
    if (header == null || header.slug != rxCurrentHeader.value?.slug) {
      return;
    }
    currentType = HeaderType.section;
    rxRecordList.clear();
    page = 1;
    fetchArticleList();
  }

  void categoryUpdateEvent(HeaderCategory? headerCategory) {
    if (headerCategory == null ||
        homeController.rxCurrentHeader.value?.slug !=
            rxCurrentHeader.value?.slug) {
      return;
    }
    rxRecordList.clear();
    page = 1;
    currentType = HeaderType.category;
    rxnHeaderCategory.value = headerCategory;
    fetchArticleList();
  }

  @override
  void onInit() async {
    super.onInit();
    sectionWorker =
        ever<Header?>(homeController.rxCurrentHeader, headerUpdateEvent);
    categoryWorker = ever<HeaderCategory?>(
        headerBarController.rxCurrentCategory, categoryUpdateEvent);
    page = 1;
    AdHelper adHelper = AdHelper();
    rxnSectionAd.value =
        await adHelper.getSectionAdBySlug(rxCurrentHeader.value?.slug);
    if (rxCurrentHeader.value?.slug == 'popular') {
      rxRecordList.value = await articlesApiProvider.getPopularArticleList();
    } else {
      fetchArticleList();
    }
  }

  void scrollEvent() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      page++;
      fetchArticleList();
    }
  }

  void fetchArticleList() async {
    List<Record> newRecordList = [];
    if (rxCurrentHeader.value?.slug == 'popular') {
      return;
    }
    if (currentType == HeaderType.section) {
      newRecordList = rxCurrentHeader.value?.type == HeaderType.section
          ? await articlesApiProvider.getArticleListBySection(
              section:
                  rxCurrentHeader.value?.slug ?? StringDefault.valueNullDefault,
              page: page)
          : await articlesApiProvider
              .getArticleListByCategoryList(page: page, list: [
              Category(id: null, name: rxCurrentHeader.value?.slug, title: null)
            ]);
    } else {
      newRecordList = await articlesApiProvider.getArticleListByCategoryList(
          page: page,
          list: [
            Category(id: null, name: rxnHeaderCategory.value?.slug, title: null)
          ]);
    }
    rxRecordList.addAll(newRecordList);
  }

  void navigateToStoryPage(Record record) {
    if (record.slug == null) {
      return;
    }
    if (record.isExternal) {
      RouteGenerator.navigateToExternalStory(record.slug!, isPremiumMode: true);
    } else {
      RouteGenerator.navigateToStory(
        record.slug!,
        isMemberCheck: record.isMemberCheck,
        url: record.url,
      );
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollEvent);
    sectionWorker?.dispose();
    categoryWorker?.dispose();
  }
}
