import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/data/providers/auth_provider.dart';
import 'package:readr_app/data/providers/local_storage_provider.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/pages/root_page/root_controller.dart';
import 'package:real_time_invoice_widget/data/provider/election_data_provider.dart';

import '../../data/providers/auth_api_provider.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthApiProvider.instance);
    Get.put(AuthProvider.instance);
    Get.put(ArticlesApiProvider.instance);
    Get.put(LocalStorageProvider.instance);
    Get.put(RootController());
    Get.put(ElectionDataProvider.create(Environment().config.electionPath));
  }
}
