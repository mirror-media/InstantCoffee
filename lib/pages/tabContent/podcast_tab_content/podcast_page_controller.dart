import 'package:get/get.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';

class PodcastPageController extends GetxController {
  final RxString rxTestString = 'test'.obs;
  final ArticlesApiProvider _articlesApiProvider =Get.find();

  void testButtonClick () async{
    await _articlesApiProvider.getPodcastInfo();


  }


}
