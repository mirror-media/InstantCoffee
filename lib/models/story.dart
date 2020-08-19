import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/categoryList.dart';
import 'package:readr_app/models/paragrpahList.dart';
import 'package:readr_app/models/peopleList.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/models/tag.dart';
import 'package:readr_app/models/tagList.dart';

class Story {
  String title;
  String subtitle;
  String slug;
  String publishedDate;
  String updatedAt;
  String createTime;
  String heroImage;
  String heroVideo;
  RecordList relatedStory;
  String heroCaption;
  String extendByline;
  TagList tags;
  PeopleList writers;
  PeopleList photographers;
  PeopleList cameraMen;
  PeopleList designers;
  PeopleList engineers;
  ParagraphList brief;
  ParagraphList apiDatas;
  String contentHtml;
  CategoryList categories;
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
    this.heroVideo,
    this.relatedStory,
    this.heroCaption,
    this.extendByline,
    this.tags,
    this.brief,
    this.apiDatas,
    this.contentHtml,
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
    ParagraphList brief = json["brief"] == null
        ? ParagraphList()
        : ParagraphList.fromJson(json["brief"]["apiData"]);
    ParagraphList apiDatas = json["content"] == null
        ? ParagraphList()
        : ParagraphList.fromJson(json["content"]["apiData"]);
    String photoUrl = mirrorMediaNotImageUrl;
    String videoUrl;
    RecordList relatedBuilder = RecordList();
    CategoryList categoryBuilder = CategoryList();
    TagList tagBuilder = TagList();
    final title = origTitle.replaceAll('　', "\n");
    if (json["relateds"] != null) {
      for (int i = 0; i < json["relateds"].length; i++) {
        Record record = Record.fromJson(json["relateds"][i]);
        relatedBuilder.add(record);
      }
    }

    if (json["categories"] != null) {
      for (int i = 0; i < json["categories"].length; i++) {
        Category category = Category.fromJson(json["categories"][i]);
        categoryBuilder.add(category);
      }
    }
    if (json["tags"] != null) {
      for (int i = 0; i < json["tags"].length; i++) {
        Tag tag = Tag.fromJson(json["tags"][i]);
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
    if (json.containsKey('heroVideo')) {
      if (json['heroVideo'] != null) {
        videoUrl = json['heroVideo']['video']['url'];
      }
    }

    return Story(
      title: title,
      subtitle: json['subtitle'] == null ? '' : json["subtitle"],
      slug: json['slug'],
      publishedDate: json['publishedDate'],
      updatedAt: json['updatedAt'],
      createTime: json['createTime'],
      heroImage: photoUrl,
      heroVideo: videoUrl,
      heroCaption: json["heroCaption"] == null ? '' : json["heroCaption"],
      extendByline: json["extend_byline"],
      relatedStory: relatedBuilder,
      brief: brief,
      apiDatas: apiDatas,
      contentHtml: json["content"] == null ? null : json["content"]["html"],
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
