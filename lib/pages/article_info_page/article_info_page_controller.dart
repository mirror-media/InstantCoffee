import 'package:get/get.dart';
import 'package:readr_app/data/enum/article_page_status.dart';
import 'package:readr_app/data/providers/articles_api_provider.dart';
import 'package:readr_app/models/article_info/article_info.dart';
import 'package:readr_app/services/auth_service.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/enum/account_status.dart';

class ArticleInfoPageController extends GetxController {
  ArticlesApiProvider articlesApiProvider = Get.find();
  AuthService authService = Get.find();

  final Rxn<ArticleInfo> rxnArticleInfo = Rxn();
  final Rx<ArticlePageStatus> rxCurrentStatus =
      Rx<ArticlePageStatus>(ArticlePageStatus.normal);
  final Rx<AccountStatus> rxAccountStatus =
      Rx<AccountStatus>(AccountStatus.loggedIn);
  final RxBool rxIsTruncated = false.obs;
  final RxBool rxIsLogin = false.obs;
  late String slug;
  late bool isMemberCheck;

  void loadArticleInfoBySlug() async {
    rxCurrentStatus.value = ArticlePageStatus.loading;
    final argument = Get.arguments as Map<String, dynamic>;
    if (argument.containsKey('slug')) {
      slug = argument['slug'];
      rxnArticleInfo.value =
          await articlesApiProvider.getArticleInfoBySlug(slug: slug);
    }

    if (argument.containsKey('isMemberCheck')) {
      isMemberCheck = argument['isMemberCheck'];
    }

    if (rxnArticleInfo.value != null) {
      // StoryRepos storyRepos= StoryService();
      // StoryRes storyRes =
      // await storyRepos.fetchStory(slug, );
      // Story story = storyRes.story;
      //
      // String storyAdJsonFileLocation = Platform.isIOS
      //     ? Environment().config.iOSStoryAdJsonLocation
      //     : Environment().config.androidStoryAdJsonLocation;
      // String storyAdString =
      // await rootBundle.loadString(storyAdJsonFileLocation);
      // final storyAdMaps = json.decode(storyAdString);
      //
      // story.storyAd = StoryAd.fromJson(storyAdMaps['other']);
      //
      // rxnArticleInfo.value!.storyAd =
    }

    rxCurrentStatus.value = rxnArticleInfo.value == null
        ? ArticlePageStatus.error
        : ArticlePageStatus.normal;
  }

  @override
  void onInit() {
    super.onInit();
    loadArticleInfoBySlug();
    rxIsLogin.value = authService.isLogin;
  }

  @override
  void onReady() {}

  void shareButtonClick() {
    final shareUrl = rxnArticleInfo.value?.shareUrl;
    if (shareUrl != null) {
      Share.share(shareUrl);
    }
  }
}
