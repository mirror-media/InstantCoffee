import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/story_ad.dart';
import 'package:readr_app/models/tag.dart';
import 'package:readr_app/pages/storyPage/news/shared/download_magazine_widget.dart';
import 'package:readr_app/pages/storyPage/news/shared/facebook_iframe_widget.dart';
import 'package:readr_app/widgets/m_m_ad_banner.dart';
import 'package:readr_app/widgets/m_m_video_player.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StoryWidget extends StatelessWidget {
  final Story story;

  const StoryWidget({
    Key? key,
    required this.story,
  }) : super(key: key);

  _fetchPublishedStoryBySlug(
      BuildContext context, String storySlug, bool isMemberCheck) {
    context
        .read<StoryBloc>()
        .add(FetchPublishedStoryBySlug(storySlug, isMemberCheck));
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

  bool _isWineCategory(List<Category> categories) {
    return categories.any((category) =>
        (category.id == Environment().config.wineSectionKey ||
            category.id == Environment().config.wine1SectionKey));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = width / 16 * 9;

    bool isAdsActivated = isStoryWidgetAdsActivated;
    bool isWineCategory = _isWineCategory(story.categories);
    StoryAd storyAd = story.storyAd!;
    Color sectionColor = _getSectionColor(story);

    return Column(
      children: [
        Expanded(
          child: ListView(children: [
            if (isAdsActivated) ...[
              const SizedBox(height: 16),
              MMAdBanner(
                adUnitId: storyAd.hDUnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              const SizedBox(height: 16),
            ],
            _buildHeroWidget(width, height, story),
            const SizedBox(height: 32),
            _buildCategoryAndPublishedDate(story, sectionColor),
            const SizedBox(height: 8),
            _buildStoryTitle(story.title),
            const SizedBox(height: 8),
            _buildAuthors(context, story),
            const SizedBox(height: 4),
            _buildBrief(story, sectionColor),
            _buildContent(story, isAdsActivated),
            const SizedBox(height: 16),
            if (isAdsActivated)
              MMAdBanner(
                adUnitId: storyAd.aT3UnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
            const SizedBox(height: 16),
            _buildUpdateDateWidget(story),
            const SizedBox(height: 24),
            FacebookIframeWidget(),
            const SizedBox(height: 16),
            _socialButtons(),
            _buildRelatedWidget(context, story.relatedStory),
            const SizedBox(height: 16),
            if (isAdsActivated) ...[
              MMAdBanner(
                adUnitId: storyAd.e1UnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              const SizedBox(height: 16),
            ],
            _buildMoreContentWidget(),
            const SizedBox(height: 24),
            _downloadMagazinesWidget(),
            const SizedBox(height: 16),
            _buildTagWidget(context, story.tags),
            const SizedBox(height: 16),
            if (isAdsActivated) ...[
              MMAdBanner(
                adUnitId: storyAd.fTUnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              const SizedBox(height: 16),
            ],
          ]),
        ),
        if (isWineCategory)
          Image.asset(
            "assets/image/wine_warning.png",
            height: 50.0,
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
            child: CachedNetworkImage(
              height: height,
              width: width,
              imageUrl: story.heroImage,
              placeholder: (context, url) => Container(
                height: height,
                width: width,
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => Container(
                height: height,
                width: width,
                color: Colors.grey,
                child: const Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
          ),
        if (story.heroCaption != '')
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Text(
              story.heroCaption!,
              style: const TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildCategory(Story story, Color sectionColor) {
    List<Category> categories = story.categories;

    if (story.isAdvertised) {
      return Container();
    }

    return InkWell(
      onTap: categories.isNotEmpty ? () {} : null,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 20,
            color: sectionColor,
          ),
          const SizedBox(width: 10),
          Text(
            (categories.isNotEmpty && categories[0].title != null)
                ? categories[0].title!
                : '娛樂頭條',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryAndPublishedDate(Story story, Color sectionColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategory(story, sectionColor),
          Text(
            story.publishedDate.formattedTaipeiDateTime() ??
                StringDefault.valueNullDefault,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600], /*fontStyle: FontStyle.italic,*/
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Text(
        title,
        style: const TextStyle(fontFamily: 'Open Sans', fontSize: 28),
      ),
    );
  }

  List<Widget> _addAuthorItems(List<People> peopleList) {
    List<Widget> authorItems = [];

    for (People author in peopleList) {
      authorItems.add(Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Text(
          author.name,
        ),
      ));
    }
    return authorItems;
  }

  Widget _buildAuthors(BuildContext context, Story story) {
    List<Widget> authorItems = [];

    // VerticalDivider is broken? so use Container
    var myVerticalDivider = Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        color: Colors.black,
        width: 1,
        height: 16,
      ),
    );

    if (story.writers.isNotEmpty) {
      authorItems.add(const Text("文"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.writers));
      authorItems.add(const SizedBox(
        width: 12.0,
      ));
    }

    if (story.photographers.isNotEmpty) {
      authorItems.add(const Text("攝影"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.photographers));
      authorItems.add(const SizedBox(
        width: 12.0,
      ));
    }

    if (story.cameraMen.isNotEmpty) {
      authorItems.add(const Text("影音"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.cameraMen));
      authorItems.add(const SizedBox(
        width: 12.0,
      ));
    }

    if (story.designers.isNotEmpty) {
      authorItems.add(const Text("設計"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.designers));
      authorItems.add(const SizedBox(
        width: 12.0,
      ));
    }

    if (story.engineers.isNotEmpty) {
      authorItems.add(const Text("工程"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.engineers));
      authorItems.add(const SizedBox(
        width: 12.0,
      ));
    }

    if (story.extendByline != '' && story.extendByline != null) {
      authorItems.add(const Text("文"));
      authorItems.add(myVerticalDivider);
      authorItems.add(Text(story.extendByline!));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/image/mm_logo_for_story.png',
              width: 32.0,
              height: 32.0,
            ),
          ),
          Expanded(
              child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: authorItems))
        ],
      ),
    );
  }

  Widget _buildBrief(Story story, Color sectionColor) {
    List<Paragraph> articles = story.brief;

    if (articles.isNotEmpty) {
      ParagraphFormat paragraphFormat = ParagraphFormat();
      List<Widget> articleWidgets = [];
      for (int i = 0; i < articles.length; i++) {
        if (articles[i].type == 'unstyled') {
          if (articles[i].contents.isNotEmpty) {
            articleWidgets.add(
              paragraphFormat.parseTheTextToHtmlWidget(
                  articles[i].contents[0].data!,
                  color: Colors.white),
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

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.maxFinite,
          color: sectionColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: articleWidgets,
            ),
          ),
        ),
      );
    }

    return Container();
  }

  _buildContent(Story story, bool isAdsActivated) {
    ParagraphFormat paragraphFormat = ParagraphFormat();
    int unStyleParagraphCount = 0;
    bool aT1IsActivated = false;
    bool aT2IsActivated = false;
    final paragraphList =
        story.apiData.isEmpty ? story.apiData : story.trimmedApiData;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paragraphList.length,
          itemBuilder: (context, index) {
            Paragraph paragraph = paragraphList[index];
            if (paragraph.contents.isNotEmpty &&
                paragraph.contents[0].data != '') {
              if (unStyleParagraphCount == storyAT1AdIndex) {
                aT1IsActivated = true;
              } else if (unStyleParagraphCount == storyAT2AdIndex) {
                aT2IsActivated = true;
              }

              if (paragraph.type == 'unstyled') {
                unStyleParagraphCount++;
              }

              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    paragraphFormat.parseTheParagraph(
                        paragraph, context, story.imageUrlList),
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
                    if (isAdsActivated &&
                        (!aT2IsActivated &&
                            unStyleParagraphCount == storyAT2AdIndex)) ...[
                      const SizedBox(height: 16),
                      MMAdBanner(
                        adUnitId: story.storyAd!.aT2UnitId,
                        adSize: AdSize.mediumRectangle,
                        isKeepAlive: true,
                      ),
                    ],
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }

  Widget _buildTagWidget(BuildContext context, List<Tag> tags) {
    return tags.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '相關關鍵字 : ',
                      style: TextStyle(fontSize: 18),
                    ),
                    _buildTags(context, tags),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
            ],
          );
  }

  Widget _buildTags(BuildContext context, List<Tag> tags) {
    List<Widget> tagWidgets = [];
    for (int i = 0; i < tags.length; i++) {
      tagWidgets.add(GestureDetector(
        onTap: () => RouteGenerator.navigateToTagPage(tags[i]),
        child: Text(
          '#${tags[i].name}',
          style: const TextStyle(fontSize: 18, color: appColor),
        ),
      ));

      if (i != tags.length - 1) {
        tagWidgets.add(
          const Text(
            '、',
            style: TextStyle(fontSize: 18, color: appColor),
          ),
        );
      }
    }
    return Wrap(
      children: tagWidgets,
    );
  }

  _buildUpdateDateWidget(Story story) {
    // VerticalDivider is broken? so use Container
    var myVerticalDivider = Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Container(
        color: Colors.black,
        width: 1,
        height: 16,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '更新時間',
          style: TextStyle(fontSize: 16),
        ),
        myVerticalDivider,
        Text(
          story.updatedAt.formattedTaipeiDateTime() ??
              StringDefault.valueNullDefault,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  _buildMoreContentWidget() {
    ParagraphFormat paragraphFormat = ParagraphFormat();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: paragraphFormat.parseTheTextToHtmlWidget(moreContentHtml,
          fontSize: 18),
    );
  }

  Widget _buildRelatedWidget(BuildContext context, List<Record> relateds) {
    List<Widget> relatedList = [];
    // VerticalDivider is broken? so use Container
    var myVerticalDivider = Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Container(
        color: appColor,
        width: 2,
        height: 24,
      ),
    );

    for (int i = 0; i < relateds.length; i++) {
      relatedList.add(_buildRelatedItem(context, relateds[i]));
    }
    return relatedList.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myVerticalDivider,
                    const Text(
                      '相關文章',
                      style: TextStyle(fontSize: 24, color: appColor),
                    ),
                    myVerticalDivider,
                  ],
                ),
                const SizedBox(height: 16),
                ...relatedList,
              ],
            ),
          );
  }

  Widget _buildRelatedItem(BuildContext context, Record relatedItem) {
    var width = MediaQuery.of(context).size.width;
    double imageWidth = 40 * (width - 32) / 100;
    double imageHeight = imageWidth * 3 / 4;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Row(
          children: [
            CachedNetworkImage(
              height: imageHeight,
              width: imageWidth,
              imageUrl: relatedItem.photoUrl,
              placeholder: (context, url) => Container(
                height: imageHeight,
                width: imageWidth,
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => Container(
                height: imageHeight,
                width: imageWidth,
                color: Colors.grey,
                child: const Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                relatedItem.title,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        AdHelper adHelper = AdHelper();
        adHelper.checkToShowInterstitialAd();

        _fetchPublishedStoryBySlug(
            context, relatedItem.slug, relatedItem.isMemberCheck);
      },
    );
  }

  _downloadMagazinesWidget() {
    return BlocProvider(
      create: (BuildContext context) => MemberSubscriptionTypeCubit(),
      child: const Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: DownloadMagazineWidget(),
      ),
    );
  }

  Widget _socialButtons() {
    Widget lineButton = TextButton.icon(
      onPressed: () => launchUrlString('https://lin.ee/dkD1s4q'),
      icon: Image.asset(lineIconPng),
      label: const Text(
        '加入',
        style: TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(74, 74, 74, 1),
        ),
      ),
    );

    Widget igButton = TextButton.icon(
      onPressed: () =>
          launchUrlString('https://www.instagram.com/mirror_media/'),
      icon: Image.asset(igIconPng),
      label: const Text(
        '追蹤',
        style: TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(74, 74, 74, 1),
        ),
      ),
    );

    Widget ytButton = TextButton.icon(
      onPressed: () => launchUrlString(
          'https://www.youtube.com/channel/UCYkldEK001GxR884OZMFnRw?sub_confirmation=1'),
      icon: Image.asset(ytIconPng),
      label: const Text(
        '訂閱',
        style: TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(74, 74, 74, 1),
        ),
      ),
    );

    Widget addMemberButton = TextButton.icon(
      onPressed: () {
        if (FirebaseAuth.instance.currentUser == null) {
          RouteGenerator.navigateToLogin();
        } else {
          RouteGenerator.navigateToSubscriptionSelect();
        }
      },
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset('assets/icon/icon.jpg', width: 32, height: 32),
      ),
      label: const Text(
        '加入會員',
        style: TextStyle(
          fontSize: 16,
          color: Color.fromRGBO(74, 74, 74, 1),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lineButton,
            const SizedBox(width: 24),
            igButton,
            const SizedBox(width: 24),
            ytButton,
          ],
        ),
        addMemberButton,
      ],
    );
  }
}
