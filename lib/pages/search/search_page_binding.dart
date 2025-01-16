import 'package:get/get.dart';
import 'package:readr_app/pages/search/search_page_controller.dart';
import 'package:readr_app/services/google_search_service.dart';

class SearchPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GoogleSearchService.instance);
    Get.lazyPut(() => SearchPageController());
  }
}
