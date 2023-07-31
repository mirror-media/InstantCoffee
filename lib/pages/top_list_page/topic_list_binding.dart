import 'package:get/get.dart';
import 'topic_list_controller.dart';

class TopicListBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => TopicListController());
  }
}