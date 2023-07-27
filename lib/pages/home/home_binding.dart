import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/pages/home/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.put(ArticlesApiProvider.instance);
  }
}