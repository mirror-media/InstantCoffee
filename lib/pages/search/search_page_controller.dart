import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final TextEditingController inputTextEditingController =
      TextEditingController();

  final RxString value = 'test'.obs;

  void searchButtonClick() {}
}
