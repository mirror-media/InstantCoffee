import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/enum/page_status.dart';
import 'package:readr_app/models/vertex_search_article.dart';
import 'package:readr_app/services/google_search_service.dart';
import 'package:readr_app/widgets/toast_factory.dart';

class SearchPageController extends GetxController {
  final TextEditingController inputTextEditingController =
      TextEditingController();
  final GoogleSearchService googleSearchService = Get.find();
  final RxList<VertexSearchArticle> rxSearchResultList = RxList();
  int searchPage = 1;
  int takeArticleOneTime = 10;
  String searchQuery = '';
  final Rx<PageStatus> rxCurrentPageStatus = PageStatus.normal.obs;
  final RxBool rxIsLoadMore = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(scrollEvent);
  }

  void searchButtonClick() async {
    searchPage = 1;
    rxSearchResultList.clear();

    if (inputTextEditingController.text.isEmpty) {
      return;
    }
    rxCurrentPageStatus.value = PageStatus.loading;
    await searchResultUpdate();
    rxCurrentPageStatus.value = PageStatus.normal;
  }

  Future<void> searchResultUpdate() async {
    final cacheSearchResult = await googleSearchService.searchDiscoveryEngine(
        query: inputTextEditingController.text,
        skip: searchPage * takeArticleOneTime,
        take: takeArticleOneTime);
    if (cacheSearchResult.isEmpty ||
        cacheSearchResult.length < takeArticleOneTime) {
      ToastFactory.showToast('已列出所有的搜尋結果', ToastType.error);
    }
    rxSearchResultList.addAll(cacheSearchResult);
  }

  void scrollEvent() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      searchPage++;
      rxIsLoadMore.value = true;
      await searchResultUpdate();
      rxIsLoadMore.value = false;
    }
  }
}
