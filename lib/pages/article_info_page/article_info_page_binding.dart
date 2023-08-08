import 'package:get/get.dart';
import 'package:readr_app/pages/article_info_page/article_info_page_controller.dart';

class ArticleInfoPagePageBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ArticleInfoPageController());
  }
}