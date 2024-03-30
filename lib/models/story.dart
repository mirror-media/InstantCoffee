import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/category.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/people.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/models/story_ad.dart';
import 'package:readr_app/models/tag.dart';

class Story {
  String? title;
  String? subtitle;
  String? slug;
  String? publishedDate;
  String? updatedAt;
  String? createTime;
  String? heroImage;
  String? heroVideo;
  List<Record>? relatedStory;
  String? heroCaption;
  String? extendByline;
  List<Tag>? tags;
  List<People>? writers;
  List<People>? photographers;
  List<People>? cameraMen;
  List<People>? designers;
  List<People>? engineers;
  List<Paragraph>? brief;
  List<Paragraph>? apiData;
  List<Paragraph>? trimmedApiData;
  List<Category>? categories;
  List<Section>? sections;
  bool? isAdult;
  bool? isAdvertised;
  bool? isMember;
  bool? isTruncated;

  String? state;
  List<String>? imageUrlList;

  StoryAd? storyAd;

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
    this.apiData,
    this.trimmedApiData,
    this.writers,
    this.photographers,
    this.cameraMen,
    this.designers,
    this.engineers,
    this.categories,
    this.sections,
    this.isAdult,
    this.isAdvertised,
    this.isMember,
    this.isTruncated,
    this.state,
    this.imageUrlList,
    this.storyAd,
  });

  factory Story.fromJsonK6(Map<String, dynamic> json) {
    final String origTitle = json['title'] ?? '';
    final String title = origTitle.replaceAll('　', "\n");

    List<Paragraph> briefList = [];
    if (json["apiDataBrief"] != null) {
      final list = json["apiDataBrief"];
      briefList = Paragraph.paragraphListFromJson(list);
    }

    List<Paragraph> apiDataList = [];
    if (json["apiData"] != null) {
      apiDataList = Paragraph.paragraphListFromJson(json["apiData"]);
    }

    List<Paragraph> trimmedApiDataList = [];
    if (json["trimmedApiData"] != null) {
      trimmedApiDataList =
          Paragraph.paragraphListFromJson(json["trimmedApiData"]);
    }

    String photoUrl = Environment().config.mirrorMediaNotImageUrl;
    String? videoUrl;
    List<String> imageUrlList = [];

    if (json.containsKey('heroImage') && json['heroImage'] != null) {
      photoUrl = json['heroImage']['resized']['w800'];
      imageUrlList.add(photoUrl);
    }
    if (json.containsKey('heroVideo')) {
      if (json['heroVideo'] != null) {
        videoUrl = json['heroVideo']['videoSrc'];
      }
    }

    for (var paragraph in apiDataList) {
      if (paragraph.contents.isNotEmpty &&
          paragraph.contents[0].data != null &&
          paragraph.contents[0].data != '') {
        if (paragraph.type == 'image') {
          imageUrlList.add(paragraph.contents[0].data!);
        } else if (paragraph.type == 'slideshow') {
          var contentList = paragraph.contents;
          for (var content in contentList) {
            imageUrlList.add(content.data!);
          }
        }
      }
    }
    List<Record> relatedList = [];
    if (json["relatedsInInputOrder"] != null) {
      relatedList = Record.recordListFromJson(json["relatedsInInputOrder"]);
    } else {
      if (json["relateds"] != null) {
        relatedList = Record.recordListFromJson(json["relateds"]);
      }
    }

    List<Category> categoriesList = [];
    if (json["categoriesInInputOrder"] != null) {
      categoriesList =
          Category.categoryListFromJson(json["categoriesInInputOrder"]);
    } else {
      if (json["categories"] != null) {
        categoriesList = Category.categoryListFromJson(json["categories"]);
      }
    }
    List<Section> sectionList = [];
    if (json["sectionsInInputOrder"] != null) {
      sectionList = Section.sectionListFromJson(json["sectionsInInputOrder"]);
    } else {
      if (json["sections"] != null) {
        sectionList = Section.sectionListFromJson(json["sections"]);
      }
    }
    List<People> writerList = [];
    if (json["writersInInputOrder"] != null) {
      writerList = People.peopleListFromJson(json["writersInInputOrder"]);
    } else {
      if (json["writers"] != null) {
        writerList = People.peopleListFromJson(json["writers"]);
      }
    }

    return Story(
      title: title,
      subtitle: json['subtitle'],
      slug: json['slug'],
      publishedDate: json['publishedDate'],
      updatedAt: json['updatedAt'],
      createTime: json['createTime'],
      heroImage: photoUrl,
      heroVideo: videoUrl,
      heroCaption: json["heroCaption"],
      extendByline: json["extend_byline"],
      relatedStory: relatedList,
      brief: briefList,
      apiData: apiDataList,
      trimmedApiData: trimmedApiDataList,
      writers: writerList,
      photographers: json["photographers"] == null
          ? []
          : People.peopleListFromJson(json["photographers"]),
      cameraMen: json["camera_man"] == null
          ? []
          : People.peopleListFromJson(json["camera_man"]),
      designers: json["designers"] == null
          ? []
          : People.peopleListFromJson(json["designers"]),
      engineers: json["engineers"] == null
          ? []
          : People.peopleListFromJson(json["engineers"]),
      categories: categoriesList,
      sections: sectionList,
      tags: json["tags"] == null ? [] : Tag.tagListFromJson(json["tags"]),
      state: json["state"],
      isAdult: json['isAdult'] ?? false,
      isTruncated: apiDataList.isEmpty,
      isMember: json['isMember'] ?? false,
      isAdvertised: json['isAdvertised'] ?? false,
      imageUrlList: imageUrlList,
    );
  }

  ///K3 fromJson 已棄用
  //factory Story.fromJson(Map<String, dynamic> json) {
  //   final String origTitle = json['title'] ?? '';
  //   final String title = origTitle.replaceAll('　', "\n");
  //
  //   List<Paragraph> briefList = [];
  //   if (json["brief"] != null && json["brief"]["apiData"] != null) {
  //     briefList = Paragraph.paragraphListFromJson(json["brief"]["apiData"]);
  //   }
  //
  //   List<Paragraph> apiDataList = [];
  //   if (json["content"] != null && json["content"]["apiData"] != null) {
  //     apiDataList = Paragraph.paragraphListFromJson(json["content"]["apiData"]);
  //   }
  //
  //   List<Paragraph> trimmedApiDataList = [];
  //   if (json["content"] != null && json["content"]["trimmedApiData"] != null) {
  //     apiDataList =
  //         Paragraph.paragraphListFromJson(json["content"]["trimmedApiData"]);
  //   }
  //
  //   String photoUrl = Environment().config.mirrorMediaNotImageUrl;
  //   String? videoUrl;
  //   List<String> imageUrlList = [];
  //
  //   if (json.containsKey('heroImage') &&
  //       json['heroImage'] != null &&
  //       (json["heroImage"] is! String) &&
  //       json['heroImage'].containsKey('image') &&
  //       json['heroImage']['image'] != null &&
  //       json['heroImage']['image'].containsKey('resizedTargets')) {
  //     photoUrl = json['heroImage']['image']['resizedTargets']['mobile']['url'];
  //     imageUrlList.add(photoUrl);
  //   }
  //   if (json.containsKey('heroVideo')) {
  //     if (json['heroVideo'] != null) {
  //       videoUrl = json['heroVideo']['video']['url'];
  //     }
  //   }
  //
  //   for (var paragraph in apiDataList) {
  //     if (paragraph.contents.isNotEmpty && paragraph.contents[0].data != '') {
  //       if (paragraph.type == 'image') {
  //         imageUrlList.add(paragraph.contents[0].data!);
  //       } else if (paragraph.type == 'slideshow') {
  //         var contentList = paragraph.contents;
  //         for (var content in contentList) {
  //           imageUrlList.add(content.data!);
  //         }
  //       }
  //     }
  //   }
  //
  //   return Story(
  //     title: title,
  //     subtitle: json['subtitle'] ?? '',
  //     slug: json['slug'] ?? '',
  //     publishedDate: json['publishedDate'] ?? '',
  //     updatedAt: json['updatedAt'] ?? '',
  //     createTime: json['createTime'] ?? '',
  //     heroImage: photoUrl,
  //     heroVideo: videoUrl,
  //     heroCaption: json["heroCaption"] ?? '',
  //     extendByline: json["extend_byline"],
  //     relatedStory: json["relateds"] == null
  //         ? []
  //         : Record.recordListFromJson(json["relateds"]),
  //     brief: briefList,
  //     apiData: apiDataList,
  //     trimmedApiData: trimmedApiDataList,
  //     writers: json["writers"] == null
  //         ? []
  //         : People.peopleListFromJson(json["writers"]),
  //     photographers: json["photographers"] == null
  //         ? []
  //         : People.peopleListFromJson(json["photographers"]),
  //     cameraMen: json["camera_man"] == null
  //         ? []
  //         : People.peopleListFromJson(json["camera_man"]),
  //     designers: json["designers"] == null
  //         ? []
  //         : People.peopleListFromJson(json["designers"]),
  //     engineers: json["engineers"] == null
  //         ? []
  //         : People.peopleListFromJson(json["engineers"]),
  //     categories: json["categories"] == null
  //         ? []
  //         : Category.categoryListFromJson(json["categories"]),
  //     sections: json["sections"] == null
  //         ? []
  //         : Section.sectionListFromJson(json["sections"]),
  //     tags: json["tags"] == null ? [] : Tag.tagListFromJson(json["tags"]),
  //     state: json["state"],
  //     isAdult: json['isAdult'] ?? false,
  //     isTruncated: json['isTruncated'] ?? false,
  //     isAdvertised: json['isAdvertised'] ?? false,
  //     imageUrlList: imageUrlList, isMember: false,
  //   );
  // }

  String? getSectionName() {
    String? sectionName;
    if (sections != null &&
        sections!.any((section) => section.name == 'member')) {
      return 'member';
    }

    if (sections != null && sections!.isNotEmpty) {
      sectionName = sections![0].name;
    }
    return sectionName;
  }

  String? getSectionTitle() {
    String? sectionTitle;
    if (sections != null && sections!.isNotEmpty) {
      sectionTitle = sections![0].title;
    }
    return sectionTitle;
  }
}
