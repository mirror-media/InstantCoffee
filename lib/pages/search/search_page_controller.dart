import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/enum/page_status.dart';
import 'package:readr_app/models/vertex_search_article.dart';
import 'package:readr_app/services/miso_search_service.dart';
import 'package:readr_app/widgets/toast_factory.dart';

class SearchPageController extends GetxController {
  final TextEditingController inputTextEditingController =
  TextEditingController();

  late final MisoSearchService misoSearchService;

  final RxList<VertexSearchArticle> rxSearchResultList = RxList();
  int searchPage = 1;
  int takeArticleOneTime = 20;
  String searchQuery = '';
  final Rx<PageStatus> rxCurrentPageStatus = PageStatus.normal.obs;
  final RxBool rxIsLoadMore = false.obs;
  final ScrollController scrollController = ScrollController();

  final Set<String> _seenProductIds = <String>{};

  @override
  void onInit() {
    super.onInit();
    misoSearchService = MisoSearchService(anonymousId: 'ANNON_ID');
    scrollController.addListener(scrollEvent);
  }

  void searchButtonClick() async {
    searchPage = 1;
    rxSearchResultList.clear();
    _seenProductIds.clear();

    if (inputTextEditingController.text.isEmpty) {
      return;
    }
    rxCurrentPageStatus.value = PageStatus.loading;
    await searchResultUpdate();
    rxCurrentPageStatus.value = PageStatus.normal;
  }

  Future<void> searchResultUpdate() async {
    final resp = await misoSearchService.search(inputTextEditingController.text);

    final List<VertexSearchArticle> mapped = [];

    for (final p in resp.products) {
      final productId = p.productId;
      if (productId.isEmpty) continue;
      if (_seenProductIds.contains(productId)) continue;
      _seenProductIds.add(productId);

      final slug = p.storySlug;
      if (slug == null || slug.isEmpty) continue;

      mapped.add(
        VertexSearchArticle(
          null, // name
          productId, // id
          StructData(
            pageSlug: [slug],
            pageImage: p.coverImage == null ? [] : [p.coverImage!],
          ),
          DerivedStructData(
            title: p.title,
          ),
        ),
      );
    }

    if (mapped.isEmpty || mapped.length < takeArticleOneTime) {
      ToastFactory.showToast('已列出所有的搜尋結果', ToastType.error);
    }

    rxSearchResultList.addAll(mapped);
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