import 'package:get/get.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import 'package:readr_app/pages/home/widgets/header_bar/header_bar_controller.dart';

class HomeBinding extends Bindings {
  dynamic arg;

  HomeBinding(this.arg);

  @override
  void dependencies() {
    Get.put(HeaderBarController());
    Get.put(HomeController(arg));
  }
}
