import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/slugBloc.dart';
import 'package:readr_app/env.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/helpers/paragraphFormat.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/paragrpahList.dart';
import 'package:readr_app/models/people.dart';
import 'package:readr_app/models/peopleList.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/storyRes.dart';
import 'package:readr_app/models/tagList.dart';
import 'package:readr_app/widgets/downloadMagazineWidget.dart';
import 'package:readr_app/widgets/fadingEffectPainter.dart';
import 'package:readr_app/widgets/mMAdBanner.dart';
import 'package:readr_app/widgets/mMVideoPlayer.dart';
import 'package:readr_app/blocs/story/bloc.dart';
import 'package:readr_app/blocs/story/events.dart';
import 'package:readr_app/blocs/story/states.dart';

class StoryWidget extends StatefulWidget {
  final SlugBloc slugBloc;
  final bool isMemberCheck;
  const StoryWidget(
      {key, @required this.slugBloc, @required this.isMemberCheck}) 
      : super(key: key);

  @override
  _StoryWidget createState() {
    return _StoryWidget();
  }
}

class _StoryWidget extends State<StoryWidget> {
  @override
  void initState() {
    _fetchPublishedStoryBySlug(widget.slugBloc.slug, widget.isMemberCheck);
    super.initState();
  }

  _fetchPublishedStoryBySlug(String storySlug, bool isMemberCheck) {
    context.read<StoryBloc>().add(
      FetchPublishedStoryBySlug(storySlug, isMemberCheck)
    );
  }

  Color _getSectionColor(Story story) {
    String sectionName;
    if (story != null) {
      sectionName = story.getSectionName();
    }

    if (sectionColorMaps.containsKey(sectionName)) {
      return Color(sectionColorMaps[sectionName]);
    }

    return appColor;
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = width / 16 * 9;
return BlocBuilder<StoryBloc, StoryState>(
      builder: (BuildContext context, StoryState state) {
        if (state is StoryError) {
          final error = state.error;
          print('StoryError: ${error.message}');
          return Container();
        }

        if (state is StoryLoaded) {
          StoryRes storyRes = state.storyRes;

          return _buildStoryWidget(storyRes, width, height);
        }

        // state is Init, Loading
        return _loadingWidget();
      }
    );
  }

  Widget _loadingWidget() {
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _buildStoryWidget(
    StoryRes storyRes,
    double width, 
    double height,
  ) {
    bool isMember = storyRes.isMember;
    Story story = storyRes.story;
    bool isTruncated = story.isTruncated;
    bool isAdsActivated = isStoryWidgetAdsActivated && isTruncated;
    Color sectionColor = _getSectionColor(story);

    return Column(
      children: [
        Expanded(
          child: ListView(children: [
            if(isAdsActivated)
            ...[
              SizedBox(height: 16),
              MMAdBanner(
                adUnitId: story.storyAd.hDUnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              SizedBox(height: 16),
            ],
            _buildHeroWidget(width, height, story),
            SizedBox(height: 32),
            _buildCategoryAndPublishedDate(context, story, sectionColor),
            SizedBox(height: 8),
            _buildStoryTitle(story.title),
            SizedBox(height: 8),
            _buildAuthors(context, story),
            SizedBox(height: 16),
            _buildBrief(story, sectionColor),
            _buildContent(story, isAdsActivated, isTruncated),
            SizedBox(height: 16),
            if(isTruncated)
            ...[
              _buildJoinMemberBlock(context, width, isMember),
              SizedBox(height: 16),
            ],
            if(isAdsActivated)
              MMAdBanner(
                adUnitId: story.storyAd.aT3UnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
            SizedBox(height: 16),
            _buildUpdateDateWidget(story),
            _buildRelatedWidget(context, story.relatedStory),
            SizedBox(height: 16),
            _buildMoreContentWidget(),
            SizedBox(height: 24),
            if(!isTruncated)
            ...[
              _buildQuoteWarningText(),
              SizedBox(height: 24),
            ],
            _downloadMagazinesWidget(),
            SizedBox(height: 24),
            if(isAdsActivated)
            ...[
              SizedBox(height: 16),
              MMAdBanner(
                adUnitId: story.storyAd.e1UnitId,
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
                adUnitId: story.storyAd.fTUnitId,
                adSize: AdSize.mediumRectangle,
                isKeepAlive: true,
              ),
              SizedBox(height: 16),
            ],
          ]),
        ),
        if(_isWineCategory(story.categories))
          Image.asset(
            "assets/image/wine_warning.png",
            height: 50.0,
          ),
        if(isAdsActivated && !_isWineCategory(story.categories))
          MMAdBanner(
            adUnitId: story.storyAd.stUnitId,
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
            videourl: story.heroVideo,
            aspectRatio: 16 / 9,
          ),
        if (story.heroImage != null && story.heroVideo == null)
          CachedNetworkImage(
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
        if (story.heroCaption != '')
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Text(
              story.heroCaption,
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryAndPublishedDate(
      BuildContext context, Story story, Color sectionColor) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategory(context, story, sectionColor),
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

  bool _isWineCategory(List<Category> categories) {
    if(categories == null) {
      return false;
    }

    for(Category category in categories) {
      if(category.id == env.baseConfig.wineSectionKey ||
      category.id == env.baseConfig.wine1SectionKey) {
        return true;
      }
    }
    return false;
  }

  Widget _buildCategory(BuildContext context, Story story, Color sectionColor) {
    List<Category> categories = List<Category>();
    if(story.categories != null) {
      categories = story.categories;
    }

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

  Widget _buildStoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Text(
        title,
        style: TextStyle(fontFamily: 'Open Sans', fontSize: 28),
      ),
    );
  }

  List<Widget> _addAuthorItems(PeopleList peopleList) {
    List<Widget> authorItems = List();

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
    List<Widget> authorItems = List();

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
      authorItems.add(Text(story.extendByline));
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
    ParagraphList articles = story.brief;

    if (articles.length > 0) {
      ParagraphFormat paragraphFormat = ParagraphFormat();
      List<Widget> articleWidgets = List();
      for (int i = 0; i < articles.length; i++) {
        if (articles[i].type == 'unstyled') {
          if (articles[i].contents.length > 0) {
            articleWidgets.add(
              paragraphFormat.parseTheTextToHtmlWidget(
                  articles[i].contents[0].data, Colors.white),
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

  _buildContent(Story story, bool isAdsActivated, bool isNeedFadding) {
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
            if (paragraph.contents != null && 
                paragraph.contents.length > 0 &&
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
                    CustomPaint(
                      foregroundPainter: (isNeedFadding && index == story.apiDatas.length-1)
                      ? FadingEffect()
                      : null,
                      child: paragraphFormat.parseTheParagraph(paragraph, context),
                    ),
                    if(isAdsActivated && (!aT1IsActivated && unStyleParagraphCount == storyAT1AdIndex)) 
                    ...[
                      SizedBox(height: 16),
                      MMAdBanner(
                        adUnitId: story.storyAd.aT1UnitId,
                        adSize: AdSize.mediumRectangle,
                        isKeepAlive: true,
                      ),
                    ],
                    if(isAdsActivated && (!aT2IsActivated && unStyleParagraphCount == storyAT2AdIndex)) 
                    ...[
                      SizedBox(height: 16),
                      MMAdBanner(
                        adUnitId: story.storyAd.aT2UnitId,
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

  Widget _buildJoinMemberBlock(BuildContext context, double width, bool isMember) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 24.0),
          child: Column(
            children: [
              Text(
                '歡迎加入鏡週刊',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: appColor,
                ),
              ),
              Text(
                '會員專區',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: appColor,
                ),
              ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: appColor),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      '限時優惠每月\$49元',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '全站看到飽',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: appColor,
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                      ),
                      child: Container(
                        width: width,
                        child: Center(
                          child: Text(
                            '加入 Premium 會員',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () => RouteGenerator.navigateToLogin(
                        context,
                        routeName: RouteGenerator.story,
                        routeArguments: {
                          'slug': widget.slugBloc.slug,
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if(!isMember)...[
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Text(
                        '立即登入',
                        style: TextStyle(
                          color: appColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () => RouteGenerator.navigateToLogin(
                        context,
                        routeName: RouteGenerator.story,
                        routeArguments: {
                          'slug': widget.slugBloc.slug,
                        },
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '享專屬優惠',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ]
          ),
        )
      ),
    );
  }

  Widget _buildTagWidget(BuildContext context, TagList tags) {
    return tags == null || tags.length == 0
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

  Widget _buildTags(BuildContext context, TagList tags) {
    if (tags == null) {
      return Container();
    } else {
      List<Widget> tagWidgets = List();
      for (int i = 0; i < tags.length; i++) {
        tagWidgets.add(
          Text(
            '#' + tags[i].name,
            style: TextStyle(fontSize: 18, color: appColor),
          ),
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
      child: paragraphFormat.parseTheTextToHtmlWidget(moreContentHtml, null, fontSize: 18),
    );
  }

  Widget _buildQuoteWarningText() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Text(
        '本新聞文字、照片、影片專供鏡週刊會員閱覽，未經鏡週刊授權，任何媒體、社群網站、論壇等均不得引用、改寫、轉貼，以免訟累。',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildRelatedWidget(BuildContext context, List<Record> relateds) {
    List<Widget> relatedList = List();
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
        widget.slugBloc.slug = relatedItem.slug;
        _fetchPublishedStoryBySlug(widget.slugBloc.slug, widget.isMemberCheck);
      },
    );
  }

  _downloadMagazinesWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: DownloadMagazineWidget(),
    );
  }
}
