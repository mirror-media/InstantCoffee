import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/search/search_page_controller.dart';

class SearchPage extends GetView<SearchPageController> {
  const SearchPage({
    Key? key,
  }) : super(key: key);

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
      onTap: () {},
    );
  }

  Widget _buildSearchList() {
    return Text('List');

    // return ListView.separated(
    //   separatorBuilder: (BuildContext context, int index) =>
    //   const SizedBox(height: 16.0),
    //   itemCount: _searchList.length + 1,
    //   itemBuilder: (context, index) {
    //     if (index == _searchList.length) {
    //       if (_isNeedToLoadMore) {
    //         return VisibilityDetector(
    //           key: const Key('SearchLoadingMore'),
    //           child: _loadingWidget(),
    //           onVisibilityChanged: (info) {
    //             var percentage = info.visibleFraction * 100;
    //             if (percentage > 0.5 &&
    //                 state != SearchState.searchLoadingMore()) {
    //               _searchNextPageByKeyword(_textController.text);
    //             }
    //           },
    //         );
    //       } else {
    //         return Container();
    //       }
    //     }
    //
    //     return SearchListItem(record: _searchList[index]);
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: const Text(
            searchPageTitle,
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          backgroundColor: appColor,
        ),
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
            Expanded(child: _buildSearchList()),
          ],
        ));
  }
}

// class SearchPage extends  {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildBar(context),
//       body: BlocProvider(
//         create: (context) => SearchCubit(searchRepos: SearchServices()),
//         child: SearchWidget(),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildBar(BuildContext context) {
//     return AppBar(
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios),
//         onPressed: () => Navigator.of(context).pop(),
//       ),
//       centerTitle: true,
//       title: const Text(
//         searchPageTitle,
//         style: TextStyle(color: Colors.white, fontSize: 24.0),
//       ),
//       backgroundColor: appColor,
//     );
//   }
// }
