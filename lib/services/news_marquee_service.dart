import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/helpers/api_base_helper.dart';
import 'package:readr_app/models/record.dart';

abstract class NewsMarqueeRepos {
  Future<List<Record>> fetchRecordList();
}

class NewsMarqueeService implements NewsMarqueeRepos {
  ApiBaseHelper helper = ApiBaseHelper();
  final ArticlesApiProvider articlesApiProvider = Get.find();

  @override
  Future<List<Record>> fetchRecordList() async {
    return await articlesApiProvider.getNewsletterList();
  }
}
