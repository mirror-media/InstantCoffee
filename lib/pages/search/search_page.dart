import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/enum/page_status.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/search/search_list_item.dart';
import 'package:readr_app/pages/search/search_page_controller.dart';
import 'package:readr_app/services/google_search_service.dart';

class SearchPage extends GetView<SearchPageController> {
  const SearchPage({
    Key? key,
  }) : super(key: key);

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text(
        searchPageTitle,
        style: TextStyle(color: Colors.white, fontSize: 24.0),
      ),
      backgroundColor: appColor,
    );
  }

  Widget _keywordTextField() {


    return SizedBox(
      width: double.maxFinite,
      child: Theme(
        data: Theme.of(Get.context!).copyWith(
          primaryColor: Colors.grey,
        ),
        child: TextField(
          controller: controller.inputTextEditingController,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            hintText: "請輸入關鍵字",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          onSubmitted: (value) {},
        ),
      ),
    );
  }

  Widget _searchButton() {
    return InkWell(
      child: Container(
        color: Colors.grey[400],
        child: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(
            Icons.search,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
      onTap: controller.searchButtonClick,
    );
  }

  @override
  Widget build(BuildContext context) {

    if (!Get.isRegistered<GoogleSearchService>()) {
      Get.put(GoogleSearchService.instance);
    }
    if (!Get.isRegistered<SearchPageController>()) {
      Get.put(SearchPageController());
    }
    return Scaffold(
        appBar: _buildBar(context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _keywordTextField(),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  _searchButton(),
                ],
              ),
            ),
            Obx(() {
              final searchList = controller.rxSearchResultList.value;
              final pageStatus = controller.rxCurrentPageStatus.value;
              return pageStatus == PageStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: appColor,
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                          controller: controller.scrollController,
                          itemBuilder: (context, index) {
                            return SearchListItem(searchList[index]);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox();
                          },
                          itemCount: searchList.length),
                    );
            }),
            Obx(() {
              final pageStatus = controller.rxIsLoadMore.value;
              return pageStatus
                  ? const CircularProgressIndicator(
                      color: appColor,
                    )
                  : const SizedBox.shrink();
            }),
          ],
        ));
  }
}
