import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/search/widgets/search_list_item.dart';

import 'search_page_controller.dart';

class SearchPage extends GetView<SearchPageController> {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Colors.grey,
                        ),
                        child: TextField(
                          controller: controller.textEditingController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
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
                          // onSubmitted: (value) => _searchByKeyword(_textController.text),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  InkWell(
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
                    onTap: () => controller.searchKeyword(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final recordList = controller.rxSearchRecordList;
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 16.0),
                  itemCount: recordList.length,
                  itemBuilder: (context, index) {
                    return SearchListItem(record: recordList[index]);
                  },
                );
              }),
            ),
          ],
        ));
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        searchPageTitle,
        style: TextStyle(color: Colors.white, fontSize: 24.0),
      ),
      backgroundColor: appColor,
    );
  }
}
