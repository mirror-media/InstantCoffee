import 'package:readr_app/helpers/Constants.dart';
import 'package:readr_app/models/SectionList.dart';
import "Record.dart";
import "Category.dart";
import "Tag.dart";
import "PeopleList.dart";
import "ParagrpahList.dart";

class Story {
  String title;
  String subtitle;
  String slug;
  String publishedDate;
  String updatedAt;
  String createTime;
  String heroImage;
  List<Record> relatedStory;
  String heroCaption;
  String extendByline;
  List<Tag> tags;
  PeopleList writers;
  PeopleList photographers;
  PeopleList cameraMen;
  PeopleList designers;
  PeopleList engineers;
  ParagraphList brief;
  ParagraphList content;
  List<Category> categories;
  SectionList sections;
  bool isAdult;
  String state;

  Story({
    this.title,
    this.subtitle,
    this.slug,
    this.publishedDate,
    this.updatedAt,
    this.createTime,
    this.heroImage,
    this.relatedStory,
    this.heroCaption,
    this.extendByline,
    this.tags,
    this.brief,
    this.content,
    this.writers,
    this.photographers,
    this.cameraMen,
    this.designers,
    this.engineers,
    this.categories,
    this.sections,
    this.isAdult,
    this.state,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    String origTitle = json['title'];
    PeopleList writersBuilder = PeopleList.fromJson(json["writers"]);
    PeopleList photographersBuilder =
        PeopleList.fromJson(json["photographers"]);
    PeopleList cameraMenBuilder = PeopleList.fromJson(json["camera_man"]);
    PeopleList designersBuilder = PeopleList.fromJson(json["designers"]);
    PeopleList engineersBuilder = PeopleList.fromJson(json["engineers"]);
    SectionList sectionBuilder = SectionList.fromJson(json["sections"]);
    ParagraphList brief = ParagraphList.fromJson(json["brief"]["apiData"]);
    ParagraphList content = ParagraphList.fromJson(json["content"]["apiData"]);
    String photoUrl = mirrorMediaNotImageUrl;
    List<Record> relatedBuilder = List();
    List<Category> categoryBuilder = List();
    List<Tag> tagBuilder = List();
    final title = origTitle.replaceAll('　', "\n");
    if (json["relateds"] != null) {
      for (int i = 0; i < json["relateds"].length; i++) {
        Record record = new Record.fromJson(json["relateds"][i]);
        relatedBuilder.add(record);
      }
    }

    if (json["categories"] != null) {
      for (int i = 0; i < json["categories"].length; i++) {
        Category category = new Category.fromJson(json["categories"][i]);
        categoryBuilder.add(category);
      }
    }
    if (json["tags"] != null) {
      for (int i = 0; i < json["tags"].length; i++) {
        Tag tag = new Tag.fromJson(json["tags"][i]);
        tagBuilder.add(tag);
      }
    }
    if (json.containsKey('heroImage') &&
        json['heroImage'] != null &&
        (json["heroImage"].runtimeType != 'String') &&
        json['heroImage'].containsKey('image') &&
        json['heroImage']['image'] != null &&
        json['heroImage']['image'].containsKey('resizedTargets')) {
      photoUrl = json['heroImage']['image']['resizedTargets']['mobile']['url'];
    }

    return new Story(
      title: title,
      subtitle: json['subtitle'] == null ? '' : json["subtitle"],
      slug: json['slug'],
      publishedDate: json['publishedDate'],
      updatedAt: json['updatedAt'],
      createTime: json['createTime'],
      heroImage: photoUrl,
      heroCaption: json["heroCaption"] == null ? '' : json["heroCaption"],
      extendByline: json["extend_byline"],
      relatedStory: relatedBuilder,
      brief: brief,
      content: content,
      writers: writersBuilder,
      photographers: photographersBuilder,
      cameraMen: cameraMenBuilder,
      designers: designersBuilder,
      engineers: engineersBuilder,
      categories: categoryBuilder,
      sections: sectionBuilder,
      tags: tagBuilder,
      state: json["state"],
      isAdult: json['isAdult'],
    );
  }
}
