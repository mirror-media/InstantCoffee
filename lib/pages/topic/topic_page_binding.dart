import 'package:get/get.dart';
import 'package:readr_app/pages/topic/topic_page_controller.dart';

class TopicPageBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => TopicPageController());
  }
}