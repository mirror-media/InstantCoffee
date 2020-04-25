import 'package:flutter/material.dart';
import 'package:readr_app/models/People.dart';
import 'dart:convert';
import "../models/StoryService.dart";
import "../models/Record.dart";
import "../models/Story.dart";
import "../models/Tag.dart";
import '../StoryPage.dart';

class StoryWidget extends StatefulWidget{
  final String slug;
  const StoryWidget ({ key, this.slug }) : super(key: key);

  @override 
  _StoryWidget createState () {
    return _StoryWidget();
  }
}

class _StoryWidget extends State<StoryWidget> {
  
  String slug;
  Story story;

  @override 
  void initState() {
    super.initState();
    getStory(widget.slug);
  }

  void getStory(String slug) async {
    String jsonString = await new StoryService().loadStory(slug);
    final jsonObject = json.decode(jsonString);
    setState(() {
      story = new Story.fromJson(jsonObject["_items"][0]);
    });
  }


  Widget build(BuildContext context) {
    if (story == null) {
      return new CircularProgressIndicator();
    } else {
      return new ListView(
        children: <Widget>[
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
                new Text(story.heroCaption),
              ],
            ),
          ),
          Row(
            children: [
              new Text("娛樂頭條"),
              new Text(story.publishedDate),
            ],
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: 
              Text(story.title, style: TextStyle(fontFamily: 'Open Sans', fontSize: 28), textAlign: TextAlign.left),
          ),
          _buildAuthors(context),
          _buildTags(context),
          _buildRelatedWidget(context, story.relatedStory),
          
        ]
      );
    }
  }

  Widget _buildTags (BuildContext context) {
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
      return Row(children: tagElement);
    }
  }

  _connectTagPage(String tagID) {
    // load the [age]
  }

  Widget _buildAuthors (BuildContext context) {
    List<Widget> authorItems = List();
    if (story.writers.peoples.length > 0) {
      authorItems.add(Text("記者："));
    }
    for (People author in story.writers.peoples) {
      Widget credit = new Card(child: Text(author.name));
      authorItems.add(credit);
    }
    if (story.photographers.peoples.length > 0) {
      authorItems.add(Text("攝影："));
    }
    for (People author in story.photographers.peoples) {
      Widget credit = new Card(child: Text(author.name));
      authorItems.add(credit);
    }
    return Row(
      children: authorItems,
    );
  }
  
  Widget _buildRelatedWidget (BuildContext context,  List<Record> relateds) {
    List<Widget> relatedList = new List();
    for (int i = 0; i < relateds.length; i++) {
      relatedList.add(_buildRelatedItem(context,relateds[i]));
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
                  )
              ),
          ),
          onTap: () {
            getStory(relatedItem.slug);
          },
        ),
      ),
    );
  }
}

