import 'package:flutter/material.dart';
import 'package:readr_app/models/paragrpahList.dart';
import 'package:readr_app/models/people.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import '../models/storyService.dart';
import '../models/record.dart';
import '../models/story.dart';
import '../models/tag.dart';
import '../models/paragraph.dart';
import '../models/category.dart';
import '../pages/listingPage.dart';

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

  @override
  void initState() {
    super.initState();
    getStory(widget.slug);
    _controller = ScrollController();
  }

  void getStory(String slug) async {
    story = await StoryService().fetchStoryList(slug);
    setState(() {});
  }

  Widget build(BuildContext context) {
    if (story == null) {
      return new CircularProgressIndicator();
    } else {
      return new ListView(controller: _controller, children: <Widget>[
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            children: <Widget>[
              new Image(
                image: NetworkImage(story.heroImage),
              ),
              new Text(story.heroCaption,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 16, height: 1.6)),
            ],
          ),
        ),
        Row(
          children: [
            //TODO: add category
            _buildCategory(context),
            Expanded(
              flex: 2,
              child: Text(story.publishedDate,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 16, height: 1.8)),
            ),
          ],
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Text(story.title,
              style: TextStyle(fontFamily: 'Open Sans', fontSize: 28),
              textAlign: TextAlign.left),
        ),
        _buildAuthors(context),
        _buildContent(context, "brief"),
        _buildContent(context, "content"),
        _buildTags(context),
        _buildRelatedWidget(context, story.relatedStory),
      ]);
    }
  }

  Widget _buildCategory(BuildContext context) {
    List<Category> categories = story.categories;
    if (categories.length > 0) {
      return RaisedButton(
          onPressed: () => _connectTagPage(categories[0].id),
          child: Text(
            categories[0].title,
          ));
    }
    return Text("娛樂頭條",
        style: TextStyle(fontFamily: 'Open Sans', fontSize: 16, height: 1.8));
  }

  List<Widget> _buildParagraph(BuildContext context, String block) {
    ParagraphList article = new ParagraphList();
    if (block == 'brief') {
      article = story.brief;
    } else if (block == 'content') {
      article = story.content;
    }
    List<Widget> content = List();
    if (article.length > 0) {
      for (Paragraph p in article) {
        switch (p.type) {
          case 'unstyled':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 20, height: 1.8)));
            }
            break;
          case 'blockquote':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 20, height: 1.8)));
            }
            break;
          case 'header-one':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 26,
                      height: 1.8,
                      fontWeight: FontWeight.bold)));
            }
            break;
          case 'header-two':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 25,
                      height: 1.8,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left));
            }
            break;
          case 'header-three':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 24,
                      height: 1.8,
                      fontWeight: FontWeight.bold)));
            }
            break;
          case 'header-four':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 23, height: 1.8)));
            }
            break;
          case 'header-five':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 22, height: 1.8)));
            }
            break;
          case 'header-six':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 21, height: 1.8)));
            }
            break;
          case 'ordered-list-item':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 20, height: 1.8)));
            }
            break;
          case 'paragraph':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 20, height: 1.8)));
            }
            break;
          case 'unordered-list-item':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 20, height: 1.8)));
            }
            break;
          case 'image':
            {
              content.add(Image(image: NetworkImage(p.content)));
            }
            break;
          case 'infobox':
            {
              content.add(Text(p.content,
                  style: TextStyle(
                      fontFamily: 'Open Sans', fontSize: 21, height: 1.8)));
            }
            break;
          case 'embeddedcode':
            {
              content.add(Container(
                  height: 500,
                  child: WebView(
                      initialUrl: Uri.dataFromString(
                              '<html><body><iframe src="' +
                                  p.content +
                                  '"></iframe></body></html>',
                              mimeType: 'text/html')
                          .toString(),
                      javascriptMode: JavascriptMode.unrestricted)));
            }
            break;
        }
      }
    }
    return content;
  }

  Widget _buildContent(BuildContext context, String block) {
    return Column(
      children: _buildParagraph(context, block),
    );
  }

  Widget _buildTags(BuildContext context) {
    if (story.tags == null) {
      return Text('foo');
    } else {
      List<Widget> tagElement = List();
      for (Tag tag in story.tags) {
        tagElement.add(RaisedButton(
            onPressed: () => _connectTagPage(tag.id),
            child: Text(
              tag.name,
            )));
      }
      return Wrap(children: tagElement);
    }
  }

  void _connectTagPage(String tagID) {
    // load the [age]
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new ListingPage()));
  }

  Widget _buildAuthors(BuildContext context) {
    List<Widget> authorItems = List();
    if (story.writers.length > 0) {
      authorItems.add(Text("記者：",
          style:
              TextStyle(fontFamily: 'Open Sans', fontSize: 18, height: 1.6)));
    }
    for (People author in story.writers) {
      Widget credit = new Card(
          child: Text(author.name,
              style: TextStyle(
                  fontFamily: 'Open Sans', fontSize: 18, height: 1.6)));
      authorItems.add(credit);
    }
    if (story.photographers.length > 0) {
      authorItems.add(Text("攝影：",
          style:
              TextStyle(fontFamily: 'Open Sans', fontSize: 18, height: 1.6)));
    }
    for (People author in story.photographers) {
      Widget credit = new Card(
          child: Text(author.name,
              style: TextStyle(
                  fontFamily: 'Open Sans', fontSize: 18, height: 1.6)));
      authorItems.add(credit);
    }
    return Row(
      children: authorItems,
    );
  }

  Widget _buildRelatedWidget(BuildContext context, List<Record> relateds) {
    List<Widget> relatedList = new List();
    for (int i = 0; i < relateds.length; i++) {
      relatedList.add(_buildRelatedItem(context, relateds[i]));
    }
    return Column(
      children: relatedList,
    );
  }

  Widget _buildRelatedItem(BuildContext context, Record relatedItem) {
    return Card(
      key: ValueKey(relatedItem.title),
      //elevation: 8.0,
      color: Colors.white,
      //margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
      child: Container(
        //decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, .4)),
        child: ListTile(
          //contentPadding:
          //EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          title: Text(
            relatedItem.title,
            style: TextStyle(color: Colors.black, height: 1.8, fontSize: 19),
          ),
          trailing: Container(
            padding: EdgeInsets.only(right: 5.0),
            child: Hero(
                tag: relatedItem.title,
                child: Image(
                  image: NetworkImage(relatedItem.photo),
                  fit: BoxFit.fitWidth,
                  colorBlendMode: BlendMode.darken,
                )),
          ),
          onTap: () {
            getStory(relatedItem.slug);
            _controller.jumpTo(1);
          },
        ),
      ),
    );
  }
}
