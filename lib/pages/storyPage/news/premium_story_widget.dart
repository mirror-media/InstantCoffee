import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/blocs/storyPage/news/bloc.dart';
import 'package:readr_app/core/extensions/string_extension.dart';
import 'package:readr_app/core/values/string.dart';
import 'package:readr_app/helpers/ad_helper.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/paragraph_format.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/people.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/story_ad.dart';
import 'package:readr_app/models/tag.dart';
import 'package:readr_app/pages/storyPage/news/shared/download_magazine_widget.dart';
import 'package:readr_app/pages/storyPage/news/shared/join_member_block.dart';
import 'package:readr_app/widgets/custom_cached_network_image.dart';
import 'package:readr_app/widgets/fading_effect_painter.dart';
import 'package:readr_app/widgets/m_m_ad_banner.dart';
import 'package:readr_app/widgets/m_m_video_player.dart';

class PremiumStoryWidget extends StatelessWidget {
  final bool isLogin;
  final Story story;

  const PremiumStoryWidget({
    required this.isLogin,
    required this.story,
  });

  _fetchPublishedStoryBySlug(
      BuildContext context, String? storySlug, bool isMemberCheck) {
    if (storySlug == null) {
      return;
    }
    context
        .read<StoryBloc>()
        .add(FetchPublishedStoryBySlug(storySlug, isMemberCheck));
  }

  bool _isWineCategory(List<Category> categories) {
    return categories.any((category) =>
        (category.name == Environment().config.wineSectionKey ||
            category.name == Environment().config.wine1SectionKey));
  }

  Color _getSectionColor(Story? story) {
    String? sectionName;
    if (story != null) {
      sectionName = story.getSectionName();
    }

    if (sectionName != null && sectionColorMaps.containsKey(sectionName)) {
      return Color(sectionColorMaps[sectionName]!);
    }

    return appColor;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = width / 16 * 9;
    StoryAd storyAd = story.storyAd!;

    bool isWineCategory = _isWineCategory(story.categories);
    bool isTruncated = story.isTruncated;
    // bool isAdsActivated = isStoryWidgetAdsActivated && isTruncated;
    bool isAdsActivated=false;
    return Column(
      children: [
        Expanded(child: _buildStoryWidget(context, width, height, story,isAdsActivated)),
        if (isWineCategory)
          Container(
            color: Colors.black,
            height: 90,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 22),
            child: Image.asset(
              "assets/image/wine_warning.png",
            ),
          ),
        if (isAdsActivated && !isWineCategory)
          MMAdBanner(
            adUnitId: storyAd.stUnitId,
            adSize: AdSize.banner,
            isKeepAlive: true,
          ),
      ],
    );
  }

  Widget _buildStoryWidget(
      BuildContext context, double width, double height, Story story,bool isAdsActivated) {
    bool isTruncated = story.isTruncated;

    StoryAd storyAd = story.storyAd!;
    Color sectionColor = _getSectionColor(story);

    return ListView(
      padding: const EdgeInsets.only(top: 24),
      children: [
        if (isAdsActivated) ...[
          MMAdBanner(
            adUnitId: storyAd.hDUnitId,
            adSize: AdSize.mediumRectangle,
            isKeepAlive: true,
          ),
          const SizedBox(height: 16),
        ],
        _buildStoryTitle(story.title),
        const SizedBox(
          height: 8,
        ),
        _buildCategoryText(story.sections, story.categories),
        const SizedBox(
          height: 32,
        ),
        _buildHeroWidget(width, height, story),
        const SizedBox(
          height: 32,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(left: 2),
          color: const Color.fromRGBO(5, 79, 119, 1),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeTile('發布時間', story.publishedDate),
                const SizedBox(
                  height: 8,
                ),
                _buildTimeTile('更新時間', story.updatedAt),
                const SizedBox(
                  height: 16,
                ),
                _buildAuthors(story),
                const SizedBox(
                  height: 24,
                ),
                _buildTagWidget(story.tags),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        _buildBrief(story.brief, story.isMember, sectionColor),
        const SizedBox(
          height: 32,
        ),
        _buildContent(story, isAdsActivated, isTruncated),
        if (isTruncated) ...[
          _joinMemberBlock(isLogin, story.slug),
        ],
        if (isAdsActivated) ...[
          const SizedBox(height: 16),
          MMAdBanner(
            adUnitId: storyAd.hDUnitId,
            adSize: AdSize.mediumRectangle,
            isKeepAlive: true,
          ),
        ],
        if (!isTruncated) ...[
          const SizedBox(height: 32),
          _buildQuoteWarningText(),
          const SizedBox(height: 12),
          _buildMoreContentWidget(),
          const SizedBox(height: 32),
          _downloadMagazinesWidget()
        ],
        const SizedBox(height: 48),
        _buildRelatedWidget(context, story.relatedStory),
        if (isAdsActivated) ...[
          MMAdBanner(
            adUnitId: storyAd.hDUnitId,
            adSize: AdSize.mediumRectangle,
            isKeepAlive: true,
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildCategoryText(List<Section> sections, List<Category> categories) {
    bool hasMemberSectoin = sections.any((section) => section.name == 'member');
    String sectionTitle = '會員專區';
    if (!hasMemberSectoin && sections.isNotEmpty) {
      sectionTitle = sections[0].title ?? StringDefault.valueNullDefault;
    }

    List<Widget> categoriesName = [];
    categoriesName.add(Text(
      sectionTitle,
      style: const TextStyle(fontSize: 16, color: appColor),
    ));
    if (categories.isNotEmpty) {
      categoriesName.add(const SizedBox(
        width: 8,
      ));
      categoriesName.add(const SizedBox(
        height: 15,
        child: VerticalDivider(
          color: Colors.black54,
          width: 2,
          thickness: 1,
        ),
      ));
      categoriesName.add(const SizedBox(
        width: 8,
      ));
      categoriesName.add(GestureDetector(
        onTap: null,
        child: Text(
          categories[0].title ?? StringDefault.valueNullDefault,
          style: const TextStyle(fontSize: 15, color: appColor),
        ),
      ));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              'assets/image/mm_logo_for_story.png',
              width: 32.0,
              height: 32.0,
            ),
          ),
          ...categoriesName
        ]);
  }

  Widget _buildStoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'PingFang TC',
          fontSize: 28,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildHeroWidget(double width, double height, Story story) {
    return Column(
      children: [
        if (story.heroVideo != null)
          MMVideoPlayer(
            videourl: story.heroVideo!,
            aspectRatio: 16 / 9,
          ),
        if (story.heroVideo == null)
          InkWell(
            onTap: () {
              if (story.heroImage !=
                      Environment().config.mirrorMediaNotImageUrl &&
                  story.imageUrlList.isNotEmpty) {
                RouteGenerator.navigateToImageViewer(story.imageUrlList);
              }
            },
            child: CustomCachedNetworkImage(
                width: width, imageUrl: story.heroImage),
          ),
        if (story.heroCaption != null && story.heroCaption != '')
          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
            child: Divider(
              color: Colors.black12,
              thickness: 1,
              height: 1,
            ),
          ),
        if (story.heroCaption != null && story.heroCaption != '')
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Text(
              story.heroCaption!,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeTile(String title, String time) {
    if (time == '' || time == ' ') {
      return Container();
    }
    return Row(
      children: [
        Text(title,
            style: const TextStyle(color: Colors.black54, fontSize: 13)),
        const SizedBox(width: 8),
        Text(
          time.formattedTaipeiDateTime() ?? StringDefault.valueNullDefault,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthors(Story story) {
    List<Widget> authorItems = [];

    if (story.writers.isNotEmpty) {
      authorItems.add(_addAuthorItems('記者', story.writers));
      authorItems.add(const SizedBox(
        height: 8.0,
      ));
    }

    if (story.photographers.isNotEmpty) {
      authorItems.add(_addAuthorItems('攝影', story.photographers));
      authorItems.add(const SizedBox(
        height: 8.0,
      ));
    }

    if (story.cameraMen.isNotEmpty) {
      authorItems.add(_addAuthorItems('影音', story.cameraMen));
      authorItems.add(const SizedBox(
        height: 8.0,
      ));
    }

    if (story.designers.isNotEmpty) {
      authorItems.add(_addAuthorItems('設計', story.designers));
      authorItems.add(const SizedBox(
        height: 8.0,
      ));
    }

    if (story.engineers.isNotEmpty) {
      authorItems.add(_addAuthorItems('工程', story.engineers));
      authorItems.add(const SizedBox(
        height: 8.0,
      ));
    }

    if (story.extendByline != '' && story.extendByline != null) {
      authorItems.add(Row(
        children: [
          const Text("記者",
              style: TextStyle(color: Colors.black54, fontSize: 15)),
          // VerticalDivider
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Container(
              color: Colors.black54,
              width: 1,
              height: 15,
            ),
          ),
          Text(
            story.extendByline!,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: authorItems,
    );
  }

  Widget _addAuthorItems(String typeText, List<People> peopleList) {
    List<Widget> authorItems = [];
    List<Widget> rowItems = [];

    rowItems.add(Text(
      typeText,
      style: const TextStyle(color: Colors.black54, fontSize: 15),
    ));

    rowItems.add(
        // VerticalDivider
        Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        color: Colors.black54,
        width: 1,
        height: 15,
      ),
    ));

    for (int i = 0; i < peopleList.length; i++) {
      authorItems.add(Text(
        peopleList[i].name,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
        ),
      ));
      if (i != peopleList.length - 1) {
        authorItems.add(Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black26,
          ),
        ));
      }
    }
    rowItems.addAll(authorItems);
    return Row(
      children: rowItems,
    );
  }

  Widget _buildTagWidget(List<Tag> tags) {
    if (tags.isEmpty) {
      return Container();
    } else {
      List<Widget> tagWidgets = [];
      for (int i = 0; i < tags.length; i++) {
        tagWidgets.add(InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.0),
              border: Border.all(color: appColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              tags[i].name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: appColor),
              strutStyle: const StrutStyle(
                  forceStrutHeight: true, fontSize: 13, height: 1.5),
            ),
          ),
          onTap: () => RouteGenerator.navigateToTagPage(tags[i]),
        ));
      }
      return Wrap(
        runSpacing: 8,
        spacing: 8,
        children: tagWidgets,
      );
    }
  }

  Widget _buildBrief(List<Paragraph> articles, bool isPremiumMemberArticle,
      Color sectionColor) {
    if (articles.isNotEmpty) {
      ParagraphFormat paragraphFormat = ParagraphFormat();
      List<Widget> articleWidgets = [];
      for (int i = 0; i < articles.length; i++) {
        if (articles[i].type == 'unstyled') {
          if (articles[i].contents.isNotEmpty) {
            articleWidgets.add(
              paragraphFormat.parseTheTextToHtmlWidget(
                  articles[i].contents[0].data!,
                  color: Colors.white,
                  fontSize: 17),
            );
          }

          if (i != articles.length - 1) {
            articleWidgets.add(
              const SizedBox(height: 16),
            );
          }
        }
      }

      if (articleWidgets.isEmpty) {
        return Container();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        color: isPremiumMemberArticle
            ? const Color.fromRGBO(5, 79, 119, 1)
            : sectionColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: articleWidgets,
        ),
      );
    }

    return Container();
  }

  Widget _buildContent(Story story, bool isAdsActivated, bool isNeedFadding) {
    ParagraphFormat paragraphFormat = ParagraphFormat();
    int unStyleParagraphCount = 0;
    bool aT1IsActivated = false;
    final paragraphList =
        story.apiData.isNotEmpty ? story.apiData : story.trimmedApiData;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paragraphList.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        Paragraph paragraph = paragraphList[index];
        if (paragraph.contents.isNotEmpty && paragraph.contents[0].data != '') {
          if (unStyleParagraphCount == storyAT1AdIndex) {
            aT1IsActivated = true;
          }
          if (paragraph.type == 'unstyled') {
            unStyleParagraphCount++;
          }

          return Column(
            children: [
              CustomPaint(
                foregroundPainter:
                    (isNeedFadding && index == paragraphList.length - 1)
                        ? FadingEffect()
                        : null,
                child: paragraphFormat.parseTheParagraph(
                  paragraph,
                  context,
                  story.imageUrlList,
                  htmlFontSize: 17,
                  isMemberContent: true,
                ),
              ),
              if (isAdsActivated &&
                  (!aT1IsActivated &&
                      unStyleParagraphCount == storyAT1AdIndex)) ...[
                const SizedBox(height: 16),
                MMAdBanner(
                  adUnitId: story.storyAd!.aT1UnitId,
                  adSize: AdSize.mediumRectangle,
                  isKeepAlive: true,
                ),
              ],
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _joinMemberBlock(bool isLogin, String storySlug) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: JoinMemberBlock(
        isMember: isLogin,
        storySlug: storySlug,
      ),
    );
  }

  Widget _buildQuoteWarningText() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Text(
        '本新聞文字、照片、影片專供鏡週刊會員閱覽，未經鏡週刊授權，任何媒體、社群網站、論壇等均不得引用、改寫、轉貼，以免訟累。',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildMoreContentWidget() {
    ParagraphFormat paragraphFormat = ParagraphFormat();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: paragraphFormat.parseTheTextToHtmlWidget(moreContentHtml,
          color: Colors.black54, fontSize: 13),
    );
  }

  Widget _downloadMagazinesWidget() {
    return BlocProvider(
      create: (BuildContext context) => MemberSubscriptionTypeCubit(),
      child: const Padding(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: DownloadMagazineWidget(
          isMemberContent: true,
        ),
      ),
    );
  }

  Widget _buildRelatedWidget(BuildContext context, List<Record> relateds) {
    List<Widget> relatedList = [];

    for (int i = 0; i < relateds.length; i++) {
      relatedList.add(_buildRelatedItem(context, relateds[i]));
    }
    return relatedList.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 24.0, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '延伸閱讀',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                ...relatedList,
              ],
            ),
          );
  }

  Widget _buildRelatedItem(BuildContext context, Record relatedItem) {
    double imageWidth = 84;
    double imageHeight = 84;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 16.0, 0.0, 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCachedNetworkImage(
                height: imageHeight,
                width: imageWidth,
                imageUrl: relatedItem.photoUrl),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                relatedItem.title ?? StringDefault.valueNullDefault,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color.fromRGBO(0, 0, 0, 0.66),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (story.isTruncated) {
          AdHelper adHelper = AdHelper();
          adHelper.checkToShowInterstitialAd();
        }

        _fetchPublishedStoryBySlug(
            context, relatedItem.slug, relatedItem.isMemberCheck);
      },
    );
  }
}
