import 'package:flutter/material.dart';

import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/helpers/dateTimeFormat.dart';
import 'package:readr_app/helpers/paragraphFormat.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/paragrpahList.dart';
import 'package:readr_app/models/people.dart';
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
  String slug;
  Story story;
  ScrollController _controller;
  Color sectionColor = appColor;

  @override
  void initState() {
    super.initState();
    getStory(widget.slug);
    _controller = ScrollController();
  }

  void getStory(String slug) async {
    story = await StoryService().fetchStoryList(slug);
    setSectionColor(story);
    setState(() {});
  }

  setSectionColor(Story story) {
    String sectionName;
    if(story != null && story.sections.length > 0) {
      sectionName = story.sections[0]?.name;
    }
    
    if(sectionColorMaps.containsKey(sectionName)) {
      sectionColor = Color(sectionColorMaps[sectionName]);
    }
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = width / 16 * 9;
    
    if (story == null) {
      return CircularProgressIndicator();
    } else {
      return ListView(
        controller: _controller, 
        children: [
          _buildHeroWidget(width, height),
          SizedBox(height: 32),
          _buildCategoryAndPublishedDate(context),
          SizedBox(height: 8),
          _buildStoryTitle(),
          SizedBox(height: 8),
          _buildAuthors(context),
          SizedBox(height: 16),
          _buildBrief(),
          _buildContent(context),
          _buildTagWidget(context),
          _buildRelatedWidget(context, story.relatedStory),
        ]
      );
    }
  }

  Widget _buildHeroWidget(double width, double height) {
    return Column(
      children: [
        if(story.heroImage != '')
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
        if(story.heroCaption != '')
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

  Widget _buildCategoryAndPublishedDate(BuildContext context) {
    DateTimeFormat dateTimeFormat = DateTimeFormat();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategory(context),
          Text(
            dateTimeFormat.changeDatabaseStringToDisplayString(story.publishedDate, 'yyyy.MM.d HH:mm'),
            style: TextStyle(fontSize: 16, color: Colors.grey[600], fontStyle: FontStyle.italic,),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context) {
    List<Category> categories = story.categories;

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
      onTap: categories.length > 0 ? (){} : null,
    );
  }

  Widget _buildStoryTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Text(
        story.title,
        style: TextStyle(fontFamily: 'Open Sans', fontSize: 28),
      ),
    );
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

    if (story.writers.length > 0) {
      authorItems.add(Text("文"));
      authorItems.add(myVerticalDivider);

      for (People author in story.writers) {
        authorItems.add(
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text(author.name,),
          )
        );
      }
      authorItems.add(SizedBox(width: 12.0,));
    }
    
    if (story.photographers.length > 0) {
      authorItems.add(Text("攝影"));
      authorItems.add(myVerticalDivider);
      for (People author in story.photographers) {
        authorItems.add(
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text(author.name,),
          )
        );
      }
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
    ParagraphList articles = story.brief;
  
    if (articles.length > 0) {
      ParagraphFormat paragraphFormat = ParagraphFormat();
      List<Widget> articleWidgets = List();
      for(int i=0; i<articles.length; i++) {
        if(articles[i].type == 'unstyled') {
          if(articles[i].contents.length > 0) {
            articleWidgets.add(
              paragraphFormat.parseTheTextToHtmlWidget(articles[i].contents[0].data, Colors.white),
            );
          }
   
          if(i != articles.length-1) {
            articleWidgets.add(
              SizedBox(height: 16),
            );
          }
        }
      }

      if(articleWidgets.length == 0) {
        return Container();
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
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

  _buildContent(BuildContext context) {
    ParagraphFormat paragraphFormat = ParagraphFormat();
    List<Widget> paragraphWidgets = List<Widget>();

    for(Paragraph paragraph in story.apiDatas) {
      paragraphWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: paragraphFormat.parseTheParagraph(paragraph, context),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: paragraphWidgets,),
    );
  }

  Widget _buildTagWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.black,),
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
        Divider(color: Colors.black,),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    if (story.tags == null) {
      return Container();
    } else {
      List<Widget> tagWidgets = List();
      for(int i=0; i<story.tags.length; i++) {
        tagWidgets.add(
          Text(
            '#'+story.tags[i].name,
            style: TextStyle(fontSize: 18, color: appColor),
          ),
        );

        if(i != story.tags.length-1)
        {
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
    double imageHeight = imageWidth*3/4;

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
