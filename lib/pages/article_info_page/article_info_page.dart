import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/pages/article_info_page/article_info_page_controller.dart';
import 'package:readr_app/pages/article_info_page/widget/article_tags_widget.dart';
import 'package:readr_app/pages/article_info_page/widget/authors_widget.dart';
import 'package:readr_app/pages/article_info_page/widget/brief_widget.dart';
import 'package:readr_app/pages/article_info_page/widget/category_text_widget.dart';
import 'package:readr_app/pages/article_info_page/widget/hero_image_widget.dart';
import 'package:readr_app/pages/article_info_page/widget/member_registration_widget.dart';
import 'package:readr_app/pages/article_info_page/widget/related_article_widget.dart';
import 'package:readr_app/pages/article_info_page/widget/subscription_widget.dart';
import 'package:readr_app/pages/article_info_page/widget/time_line_widget.dart';
import 'package:readr_app/widgets/paragraph_widget_factory/paragraph_widget_factory.dart';

import '../../data/enum/account_status.dart';
import '../../data/enum/article_page_status.dart';
import '../../helpers/data_constants.dart';
import '../../helpers/route_generator.dart';
import '../../models/article_info/article_info.dart';
import '../../widgets/m_m_ad_banner.dart';

class ArticleInfoPage extends GetView<ArticleInfoPageController> {
  const ArticleInfoPage({Key? key}) : super(key: key);

  Widget _renderArticleInfo(ArticleInfo articleInfo) {
    return Column(
      children: [
        if (articleInfo.isAdvertised == true &&
            articleInfo.storyAd != null) ...[
          MMAdBanner(
            adUnitId: articleInfo.storyAd!.hDUnitId,
            adSize: AdSize.mediumRectangle,
            isKeepAlive: true,
          ),
        ],
        const SizedBox(height: 16),
        CategoryTextWidget(categoriesList: articleInfo.categoryDisplayList),
        const SizedBox(
          height: 8,
        ),
        Text(
          articleInfo.title ?? StringDefault.valueNullDefault,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'PingFang TC',
            fontSize: 28,
            color: Colors.black87,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        HeroImageWidget(articleInfo: articleInfo),
        const SizedBox(
          height: 32,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(left: 2),
          color: const Color.fromRGBO(5, 79, 119, 1),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeLineWidget(title: '發布時間', time: articleInfo.publishedDate!),
                const SizedBox(
                  height: 8,
                ),
                TimeLineWidget(title: '更新時間', time: articleInfo.updatedAt!),
                const SizedBox(
                  height: 16,
                ),
                AuthorsWidget(authorList: articleInfo.authorList),
                const SizedBox(
                  height: 24,
                ),
                ArticleTagsWidget(articleTags: articleInfo.tags),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        BriefWidget(
            brief: articleInfo.brief,
            sectionColor:
                !controller.isMemberCheck && articleInfo.sectionColor != null
                    ? articleInfo.sectionColor!
                    : const Color.fromRGBO(5, 79, 119, 1)),
        const SizedBox(
          height: 24,
        ),
        if (articleInfo.paragraphList != null)
          ...articleInfo.paragraphList!
              .map((e) => ParagraphWidgetFactory.create(e))
              .toList(),
        const SizedBox(
          height: 24,
        ),
        Obx(() {
          final isTruncated = controller.rxIsTruncated.value;
          return isTruncated
              ? MemberRegistrationWidget(
                  accountStatus: AccountStatus.loggedIn,
                  joinButtonClickEvent: (status) {})
              : const SizedBox.shrink();
        }),
        const SizedBox(height: 16),
        if (articleInfo.isAdvertised == true && articleInfo.storyAd != null)
          MMAdBanner(
            adUnitId: articleInfo.storyAd!.hDUnitId,
            adSize: AdSize.mediumRectangle,
            isKeepAlive: true,
          ),
        Obx(() {
          final isTruncated = controller.rxIsTruncated.value;
          return true ? const SubscriptionWidget() : const SizedBox.shrink();
        }),
        RelatedArticleWidget(
          postList: articleInfo.relatedArticles ?? [],
          itemClickEvent: (slug) {
            if (slug != null) {
              RouteGenerator.navigateToStory(slug);
            }
          },
        ),
        if (articleInfo.isAdvertised == true && articleInfo.storyAd != null)
          MMAdBanner(
            adUnitId: articleInfo.storyAd!.hDUnitId,
            adSize: AdSize.mediumRectangle,
            isKeepAlive: true,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.until((route) =>
              route.settings.name == '/' ||
              route.settings.name == '/TopicPage'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'share',
            onPressed: () => controller.shareButtonClick(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            final status = controller.rxCurrentStatus.value;
            switch (status) {
              case ArticlePageStatus.error:
                return const Text('錯誤');
              case ArticlePageStatus.normal:
                return Obx(() {
                  final articleInfo = controller.rxnArticleInfo.value;
                  return _renderArticleInfo(articleInfo!);
                });
              case ArticlePageStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          }),
        ),
      ),
    );
  }
}
