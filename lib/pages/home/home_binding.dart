import 'package:get/get.dart';
import 'package:readr_app/pages/home/home_controller.dart';

class HomeBinding extends Bindings {
  dynamic arg;

  HomeBinding(this.arg);

  @override
  void dependencies() {
    Get.put(HomeController(arg));
  }
}
