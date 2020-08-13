import 'package:flutter/material.dart';

import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/helpers/paragraphFormat.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/paragrpahList.dart';
import 'package:readr_app/models/people.dart';
import 'package:readr_app/models/peopleList.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/story.dart';
import 'package:readr_app/models/storyService.dart';
import 'package:readr_app/pages/listingPage.dart';

import 'package:cached_network_image/cached_network_image.dart';

class StoryWidget extends StatefulWidget {
  final String slug;
  const StoryWidget({key, this.slug}) : super(key: key);

  @override
  _StoryWidget createState() {
    return _StoryWidget();
  }
}

class _StoryWidget extends State<StoryWidget> {
  Story _story;
  ScrollController _controller;
  Color _sectionColor = appColor;

  @override
  void initState() {
    super.initState();
    getStory(widget.slug);
    _controller = ScrollController();
  }

  void getStory(String slug) async {
    _story = await StoryService().fetchStoryList(slug);
    setSectionColor(_story);
    setState(() {});
  }

  setSectionColor(Story story) {
    String sectionName;
    if (story != null && story.sections.length > 0) {
      sectionName = story.sections[0]?.name;
    }

    if (sectionColorMaps.containsKey(sectionName)) {
      _sectionColor = Color(sectionColorMaps[sectionName]);
    }
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = width / 16 * 9;

    if (_story == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView(controller: _controller, children: [
        _buildHeroWidget(width, height),
        SizedBox(height: 32),
        _buildCategoryAndPublishedDate(context),
        SizedBox(height: 8),
        _buildStoryTitle(),
        SizedBox(height: 8),
        _buildAuthors(context),
        SizedBox(height: 16),
        _buildBrief(),
        _buildContent(),
        SizedBox(height: 32),
        _buildUpdateDateWidget(),
        SizedBox(height: 16),
        _buildTagWidget(context),
        _buildRelatedWidget(context, _story.relatedStory),
      ]);
    }
  }

  Widget _buildHeroWidget(double width, double height) {
    return Column(
      children: [
        if (_story.heroImage != '')
          CachedNetworkImage(
            height: height,
            width: width,
            imageUrl: _story.heroImage,
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
        if (_story.heroCaption != '')
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Text(
              _story.heroCaption,
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryAndPublishedDate(BuildContext context) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategory(context),
          Text(
            dateTimeFormat.changeDatabaseStringToDisplayString(
                _story.publishedDate, 'yyyy.MM.dd HH:mm'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600], /*fontStyle: FontStyle.italic,*/
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context) {
    List<Category> categories = _story.categories;

    return InkWell(
      child: Row(
        children: [
          Container(
            width: 10,
            height: 20,
            color: _sectionColor,
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

  Widget _buildStoryTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Text(
        _story.title,
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

  Widget _buildAuthors(BuildContext context) {
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

    if (_story.writers.length > 0) {
      authorItems.add(Text("文"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(_story.writers));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (_story.photographers.length > 0) {
      authorItems.add(Text("攝影"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(_story.photographers));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (_story.cameraMen.length > 0) {
      authorItems.add(Text("影音"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(_story.cameraMen));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (_story.designers.length > 0) {
      authorItems.add(Text("設計"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(_story.designers));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (_story.engineers.length > 0) {
      authorItems.add(Text("工程"));
      authorItems.add(myVerticalDivider);

      authorItems.addAll(_addAuthorItems(_story.engineers));
      authorItems.add(SizedBox(
        width: 12.0,
      ));
    }

    if (_story.extendByline != '' && _story.extendByline != null) {
      authorItems.add(Text("文"));
      authorItems.add(myVerticalDivider);
      authorItems.add(Text(_story.extendByline));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: authorItems,
      ),
    );
  }

  Widget _buildBrief() {
    ParagraphList articles = _story.brief;

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
          color: _sectionColor,
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

  _buildContent() {
    ParagraphFormat paragraphFormat = ParagraphFormat();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _story.apiDatas.length,
          itemBuilder: (context, index) {
            Paragraph paragraph = _story.apiDatas[index];
            if (paragraph.contents.length > 0 &&
                paragraph.contents[0].data != '') {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: paragraphFormat.parseTheParagraph(paragraph, context),
              );
            }
            return Container();
          }),
    );
  }

  Widget _buildTagWidget(BuildContext context) {
    return Column(
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
              _buildTags(context),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    if (_story.tags == null) {
      return Container();
    } else {
      List<Widget> tagWidgets = List();
      for (int i = 0; i < _story.tags.length; i++) {
        tagWidgets.add(
          Text(
            '#' + _story.tags[i].name,
            style: TextStyle(fontSize: 18, color: appColor),
          ),
        );

        if (i != _story.tags.length - 1) {
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

  void _connectTagPage(String tagID) {
    // load the [age]
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListingPage()));
  }

  _buildUpdateDateWidget() {
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
              _story.updatedAt, 'yyyy.MM.dd HH:mm'),
          style: TextStyle(fontSize: 16),
        ),
      ],
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
    return Padding(
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
              imageUrl: relatedItem.photo,
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
        getStory(relatedItem.slug);
        _controller.jumpTo(1);
      },
    );
  }
}
