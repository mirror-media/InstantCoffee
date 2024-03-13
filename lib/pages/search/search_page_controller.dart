import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/models/record.dart';

class SearchPageController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final ArticlesApiProvider articlesApiProvider = Get.find();
  final RxList<Record> rxSearchRecordList = RxList();

  void searchKeyword() async {
    final keyword = textEditingController.text;
    final result = await articlesApiProvider.searchByKeyword(keyword);
    rxSearchRecordList.value = result.recordList;
  }
}
