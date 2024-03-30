import 'package:get/get.dart';
import 'package:readr_app/pages/article_page/article_controller.dart';

class ArticleBinding extends Bindings {
  dynamic arg;

  ArticleBinding(this.arg);

  @override
  void dependencies() {
    Get.lazyPut(() => ArticleController(arg));
  }
}
