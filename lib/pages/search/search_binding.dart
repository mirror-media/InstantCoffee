import 'package:get/get.dart';
import 'package:readr_app/pages/search/search_page_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchPageController());
  }
}
