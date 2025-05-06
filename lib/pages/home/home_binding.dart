import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/data/providers/auth_info_provider.dart';
import 'package:readr_app/data/providers/graph_ql_provider.dart';
import 'package:readr_app/data/providers/local_storage_provider.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/pages/home/home_controller.dart';
import 'package:readr_app/services/app_cache_service.dart';

import 'package:real_time_invoice_widget/data/provider/election_data_provider.dart';

import '../../data/providers/auth_api_provider.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppCacheService());
    Get.lazyPut(() => HomeController());
    Get.put(AuthApiProvider.instance);
    Get.put(AuthInfoProvider.instance);
    Get.put(ArticlesApiProvider.instance);
    Get.put(LocalStorageProvider.instance);
    // Get.put(GoogleSearchService());

    Get.put(GraphQLLinkProvider());
    Get.put(ElectionDataProvider.create(Environment().config.electionPath));
  }
}
