import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/people.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/storyAd.dart';
import 'package:readr_app/models/tag.dart';

class Story {
  String title;
  String subtitle;
  String slug;
  String publishedDate;
  String updatedAt;
  String createTime;
  String heroImage;
  String? heroVideo;
  List<Record> relatedStory;
  String? heroCaption;
  String? extendByline;
  List<Tag> tags;
  List<People> writers;
  List<People> photographers;
  List<People> cameraMen;
  List<People> designers;
  List<People> engineers;
  List<Paragraph> brief;
  List<Paragraph> apiDatas;
  List<Category> categories;
  List<Section> sections;
  bool isAdult;
  bool isAdvertised;
  bool isTruncated;
  String? state;
  List<String> imageUrlList;

  StoryAd? storyAd;

  Story({
    required this.title,
    required this.subtitle,
    required this.slug,
    required this.publishedDate,
    required this.updatedAt,
    required this.createTime,
    required this.heroImage,
    required this.heroVideo,
    required this.relatedStory,
    required this.heroCaption,
    required this.extendByline,
    required this.tags,
    required this.brief,
    required this.apiDatas,
    required this.writers,
    required this.photographers,
    required this.cameraMen,
    required this.designers,
    required this.engineers,
    required this.categories,
    required this.sections,
    required this.isAdult,
    required this.isAdvertised,
    required this.isTruncated,
    required this.state,
    required this.imageUrlList,

    this.storyAd,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    final String origTitle = json['title'] ?? '';
    final String title = origTitle.replaceAll('　', "\n");
    
    List<Paragraph> briefList = [];
    if(json["brief"] != null && json["brief"]["apiData"] != null) {
      briefList = Paragraph.paragraphListFromJson(json["brief"]["apiData"]);
    }

    List<Paragraph> apiDataList = [];
    if(json["content"] != null && json["content"]["apiData"] != null) {
      apiDataList = Paragraph.paragraphListFromJson(json["content"]["apiData"]);
    }

    String photoUrl = Environment().config.mirrorMediaNotImageUrl;
    String? videoUrl;
    List<String> imageUrlList = [];

    if (json.containsKey('heroImage') &&
        json['heroImage'] != null &&
        (!(json["heroImage"] is String)) &&
        json['heroImage'].containsKey('image') &&
        json['heroImage']['image'] != null &&
        json['heroImage']['image'].containsKey('resizedTargets')) {
      photoUrl = json['heroImage']['image']['resizedTargets']['mobile']['url'];
      imageUrlList.add(photoUrl);
    }
    if (json.containsKey('heroVideo')) {
      if (json['heroVideo'] != null) {
        videoUrl = json['heroVideo']['video']['url'];
      }
    }

    for(var paragraph in apiDataList){
      if (paragraph.contents.length > 0 &&
        paragraph.contents[0].data != ''){
        if(paragraph.type == 'image'){
          imageUrlList.add(paragraph.contents[0].data!);
        }else if(paragraph.type == 'slideshow'){
          var contentList = paragraph.contents;
          for(var content in contentList){
            imageUrlList.add(content.data!);
          }
        }
      }
    }

    return Story(
      title: title,
      subtitle: json['subtitle'] ?? '',
      slug: json['slug'] ?? '',
      publishedDate: json['publishedDate'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      createTime: json['createTime'] ?? '',
      heroImage: photoUrl,
      heroVideo: videoUrl,
      heroCaption: json["heroCaption"] ?? '',
      extendByline: json["extend_byline"],
      relatedStory: json["relateds"] == null ? [] : Record.recordListFromJson(json["relateds"]),
      brief: briefList,
      apiDatas: apiDataList,
      writers: json["writers"] == null ? [] : People.peopleListFromJson(json["writers"]),
      photographers: json["photographers"] == null ? [] : People.peopleListFromJson(json["photographers"]),
      cameraMen: json["camera_man"] == null ? [] : People.peopleListFromJson(json["camera_man"]),
      designers: json["designers"] == null ? [] : People.peopleListFromJson(json["designers"]),
      engineers: json["engineers"] == null ? [] : People.peopleListFromJson(json["engineers"]),
      categories: json["categories"] == null ? [] : Category.categoryListFromJson(json["categories"]),
      sections: json["sections"] == null ? [] : Section.sectionListFromJson(json["sections"]),
      tags: json["tags"] == null ? [] : Tag.tagListFromJson(json["tags"]),
      state: json["state"],
      isAdult: json['isAdult'] ?? false,
      isTruncated: json['isTruncated'] ?? false,
      isAdvertised: json['isAdvertised'] ?? false,
      imageUrlList: imageUrlList,
    );
  }

  String? getSectionName() {
    String? sectionName;
    if (sections.length > 0) {
      sectionName = sections[0].name;
    }
    return sectionName;
  }
}
