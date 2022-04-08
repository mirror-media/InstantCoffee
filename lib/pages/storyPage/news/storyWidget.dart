import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberSubscriptionType/cubit.dart';
import 'package:readr_app/blocs/storyPage/news/bloc.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/helpers/paragraphFormat.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/people.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/storyAd.dart';
import 'package:readr_app/models/tag.dart';
import 'package:readr_app/pages/storyPage/news/shared/downloadMagazineWidget.dart';
import 'package:readr_app/pages/storyPage/news/shared/facebookIframeWidget.dart';
import 'package:readr_app/widgets/mMAdBanner.dart';
import 'package:readr_app/widgets/mMVideoPlayer.dart';
import 'package:url_launcher/url_launcher.dart';

class StoryWidget extends StatelessWidget {
  final Story story;
  StoryWidget({
    required this.story,
  });
  
  late final StoryBloc _storyBloc;
  _fetchPublishedStoryBySlug(String storySlug, bool isMemberCheck) {
    _storyBloc.add(
      FetchPublishedStoryBySlug(storySlug, isMemberCheck)
    );
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
      (category.id == Environment().config.wineSectionKey || category.id == Environment().config.wine1SectionKey)
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = width / 16 * 9;

    _storyBloc = context.read<StoryBloc>();
    bool isAdsActivated = isStoryWidgetAdsActivated;
    bool isWineCategory = _isWineCategory(story.categories);
    StoryAd storyAd = story.storyAd!;
    Color sectionColor = _getSectionColor(story);

    return Column(
      children: [
        Expanded(
          child: ListView(children: [
            if(isAdsActivated)
            ...[
              SizedBox(height: 16),
              MMAdBanner(
                adUnitId: storyAd.hDUnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              SizedBox(height: 16),
            ],
            _buildHeroWidget(width, height, story),
            SizedBox(height: 32),
            _buildCategoryAndPublishedDate(story, sectionColor),
            SizedBox(height: 8),
            _buildStoryTitle(story.title),
            SizedBox(height: 8),
            _buildAuthors(context, story),
            SizedBox(height: 16),
            _buildBrief(story, sectionColor),
            _buildContent(story, isAdsActivated),
            SizedBox(height: 16),
            if(isAdsActivated)
              MMAdBanner(
                adUnitId: storyAd.aT3UnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
            SizedBox(height: 16),
            _buildUpdateDateWidget(story),
            SizedBox(height: 24),
            FacebookIframeWidget(),
            SizedBox(height: 16),
            _socialButtons(),
            _buildRelatedWidget(context, story.relatedStory),
            SizedBox(height: 16),
            _buildMoreContentWidget(),
            SizedBox(height: 24),
            _downloadMagazinesWidget(),
            SizedBox(height: 24),
            if(isAdsActivated)
            ...[
              SizedBox(height: 16),
              MMAdBanner(
                adUnitId: storyAd.e1UnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              SizedBox(height: 16),
            ],
            SizedBox(height: 16),
            _buildTagWidget(context, story.tags),
            if(isAdsActivated)
            ...[
              MMAdBanner(
                adUnitId: storyAd.fTUnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              SizedBox(height: 16),
            ],
          ]),
        ),

        if(isWineCategory)
          Image.asset(
            "assets/image/wine_warning.png",
            height: 50.0,
          ),
        if(isAdsActivated && !isWineCategory)
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
            onTap: (){
              if(story.heroImage != Environment().config.mirrorMediaNotImageUrl
                && story.imageUrlList.isNotEmpty
              ){
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
                child: Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
          ),
        if (story.heroCaption != '')
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Text(
              story.heroCaption!,
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildCategory(Story story, Color sectionColor) {
    List<Category> categories= story.categories;

    if(story.isAdvertised) {
      return Container();
    }

    return InkWell(
      child: Row(
        children: [
          Container(
            width: 10,
            height: 20,
            color: sectionColor,
          ),
          SizedBox(width: 10),
          Text(
            categories.length > 0 ? categories[0].title : '娛樂頭條',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      onTap: categories.length > 0 ? () {} : null,
    );
  }

  Widget _buildCategoryAndPublishedDate(Story story, Color sectionColor) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategory(story, sectionColor),
          Text(
            dateTimeFormat.changeDatabaseStringToDisplayString(
                story.publishedDate, 'yyyy.MM.dd HH:mm'),
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
        style: TextStyle(fontFamily: 'Open Sans', fontSize: 28),
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

    if (story.writers.length > 0) {
      authorItems.add(Text("文"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.writers));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (story.photographers.length > 0) {
      authorItems.add(Text("攝影"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.photographers));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (story.cameraMen.length > 0) {
      authorItems.add(Text("影音"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.cameraMen));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (story.designers.length > 0) {
      authorItems.add(Text("設計"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.designers));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (story.engineers.length > 0) {
      authorItems.add(Text("工程"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(story.engineers));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (story.extendByline != '' && story.extendByline != null) {
      authorItems.add(Text("文"));
      authorItems.add(myVerticalDivider);
      authorItems.add(Text(story.extendByline!));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: authorItems,
      ),
    );
  }

  Widget _buildBrief(Story story, Color sectionColor) {
    List<Paragraph> articles = story.brief;

    if (articles.length > 0) {
      ParagraphFormat paragraphFormat = ParagraphFormat();
      List<Widget> articleWidgets = [];
      for (int i = 0; i < articles.length; i++) {
        if (articles[i].type == 'unstyled') {
          if (articles[i].contents.length > 0) {
            articleWidgets.add(
              paragraphFormat.parseTheTextToHtmlWidget(
                  articles[i].contents[0].data!, color: Colors.white),
            );
          }

          if (i != articles.length - 1) {
            articleWidgets.add(
              SizedBox(height: 16),
            );
          }
        }
      }

      if (articleWidgets.length == 0) {
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: story.apiDatas.length,
          itemBuilder: (context, index) {
            Paragraph paragraph = story.apiDatas[index];
            if (paragraph.contents.length > 0 &&
                paragraph.contents[0].data != '') {
              if(unStyleParagraphCount == storyAT1AdIndex) {
                aT1IsActivated = true;
              }
              else if(unStyleParagraphCount == storyAT2AdIndex) {
                aT2IsActivated = true;
              }

              if(paragraph.type == 'unstyled') {
                unStyleParagraphCount ++;
              }

              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    paragraphFormat.parseTheParagraph(paragraph, context, story.imageUrlList),
                    if(isAdsActivated && (!aT1IsActivated && unStyleParagraphCount == storyAT1AdIndex)) 
                    ...[
                      SizedBox(height: 16),
                      MMAdBanner(
                        adUnitId: story.storyAd!.aT1UnitId,
                        adSize: AdSize.mediumRectangle,
                        isKeepAlive: true,
                      ),
                    ],
                    if(isAdsActivated && (!aT2IsActivated && unStyleParagraphCount == storyAT2AdIndex)) 
                    ...[
                      SizedBox(height: 16),
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
    return tags.length == 0
    ? Container()
    : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '相關關鍵字 : ',
                  style: TextStyle(fontSize: 18),
                ),
                _buildTags(context, tags),
              ],
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      );
  }

  Widget _buildTags(BuildContext context, List<Tag> tags) {
    List<Widget> tagWidgets = [];
    for (int i = 0; i < tags.length; i++) {
      tagWidgets.add(
        GestureDetector(
          onTap: () => RouteGenerator.navigateToTagPage(tags[i]),
          child: Text(
            '#' + tags[i].name,
            style: TextStyle(fontSize: 18, color: appColor),
          ),
        )
      );

      if (i != tags.length - 1) {
        tagWidgets.add(
          Text(
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
    DateTimeFormat dateTimeFormat = DateTimeFormat();

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
        Text(
          '更新時間',
          style: TextStyle(fontSize: 16),
        ),
        myVerticalDivider,
        Text(
          dateTimeFormat.changeDatabaseStringToDisplayString(
              story.updatedAt, 'yyyy.MM.dd HH:mm'),
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  _buildMoreContentWidget() {
    ParagraphFormat paragraphFormat = ParagraphFormat();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: paragraphFormat.parseTheTextToHtmlWidget(moreContentHtml, fontSize: 18),
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
    return relatedList.length == 0
    ? Container()
    : Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                myVerticalDivider,
                Text(
                  '相關文章',
                  style: TextStyle(fontSize: 24, color: appColor),
                ),
                myVerticalDivider,
              ],
            ),
            SizedBox(height: 16),
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
                child: Icon(Icons.error),
              ),
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                relatedItem.title,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _fetchPublishedStoryBySlug(relatedItem.slug, relatedItem.isMemberCheck);
      },
    );
  }

  _downloadMagazinesWidget() {
    return BlocProvider(
      create: (BuildContext context) => MemberSubscriptionTypeCubit(),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: DownloadMagazineWidget(),
      ),
    );
  }

  Widget _socialButtons(){
    Widget lineButton = TextButton.icon(
      onPressed: () => launch('https://lin.ee/dkD1s4q'), 
      icon: Image.asset(lineIconPng), 
      label: Text('加入', 
        style: TextStyle(
          fontSize: 16, 
          color: Color.fromRGBO(74, 74, 74, 1),
        ),
      ),
    );

    Widget igButton = TextButton.icon(
      onPressed: () => launch('https://www.instagram.com/mirror_media/'), 
      icon: Image.asset(igIconPng), 
      label: Text('追蹤', 
        style: TextStyle(
          fontSize: 16, 
          color: Color.fromRGBO(74, 74, 74, 1),
        ),
      ),
    );

    Widget ytButton = TextButton.icon(
      onPressed: () => launch('https://www.youtube.com/channel/UCYkldEK001GxR884OZMFnRw?sub_confirmation=1'), 
      icon: Image.asset(ytIconPng), 
      label: Text('訂閱', 
        style: TextStyle(
          fontSize: 16, 
          color: Color.fromRGBO(74, 74, 74, 1),
        ),
      ),
    );

    Widget addMemberButton = TextButton.icon(
      onPressed: (){
        if(FirebaseAuth.instance.currentUser == null){
          RouteGenerator.navigateToLogin();
        } else {
          RouteGenerator.navigateToSubscriptionSelect();
        }
      }, 
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset('assets/icon/icon.jpg', width: 32, height: 32),
      ), 
      label: Text('加入會員', 
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