import 'package:get/get.dart';
import 'package:readr_app/data/providers/account_api_provider.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/data/providers/local_storage_provider.dart';
import 'package:readr_app/pages/home/home_controller.dart';

import '../../services/auth_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.put(ArticlesApiProvider.instance);
    Get.put(AccountApiProvider.instance);
    Get.put(AuthService.instance);
    Get.put(LocalStorageProvider.instance);
  }
}
