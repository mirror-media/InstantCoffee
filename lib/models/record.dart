import 'package:equatable/equatable.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/category.dart';

class Record extends Equatable {
  final String title;
  final String slug;
  final String publishedDate;
  final String photoUrl;
  final bool isExternal;
  final bool isMemberCheck;
  final String? url;

  const Record({
    required this.title,
    required this.slug,
    required this.publishedDate,
    required this.photoUrl,
    this.isExternal = false,
    this.isMemberCheck = true,
    this.url,
  });

  factory Record.fromJsonK6(Map<String, dynamic> json) {
    // check the search json format
    if (json.containsKey('_source')) {
      json = json['_source'];
    }

    String origTitle;
    if (json.containsKey('snippet')) {
      origTitle = json['snippet']['title'];
    } else {
      origTitle = json['title'];
    }
    String origSlug = '';
    if (json.containsKey('id') &&
        json['id'] is Map<String, dynamic> &&
        (json['id'] as Map).containsKey('videoId') &&
        json['id']['videoId'] != null) {
      origSlug = json['id']['videoId'];
    } else {
      origSlug = json['slug'];
    }

    String origPublishedDate;
    if (json.containsKey('publishedDate')) {
      origPublishedDate = json['publishedDate'] ?? '';
    } else {
      origPublishedDate = json['publishTime'] ?? '';
    }

    String photoUrl = Environment().config.mirrorMediaNotImageUrl;
    if (json.containsKey('heroImage') && json['heroImage'] != null) {
      photoUrl = json['heroImage']['resized']['original'];
    }
    if (json.containsKey('snippet')) {
      photoUrl = json['snippet']['thumbnails']['medium']['url'];
    }

    if (photoUrl == '') {
      photoUrl = Environment().config.mirrorMediaNotImageUrl;
    }

    List<Category> categoryBuilder = [];

    categoryBuilder = json["categories"] == null || json["categories"] == ""
        ? []
        : Category.categoryListFromJson(json["categories"]);

    String? url;
    if (json.containsKey('style')) {
      if (json['style'] == 'projects') {
        url = '${Environment().config.mirrorMediaDomain}/projects/$origSlug';
      } else if (json['style'] == 'campaign') {
        url = '${Environment().config.mirrorMediaDomain}/campaigns/$origSlug';
      }
    }

    return Record(
      title: origTitle,
      slug: origSlug,
      publishedDate: origPublishedDate,
      photoUrl: photoUrl,
      isExternal: json["partner"] != null && json["partner"] != "",
      isMemberCheck: Category.isMemberOnlyInCategoryList(categoryBuilder),
      url: url,
    );
  }

  factory Record.fromJson(Map<String, dynamic> json) {
    // check the search json format
    if (json.containsKey('_source')) {
      json = json['_source'];
    }

    String origTitle;
    if (json.containsKey('snippet')) {
      origTitle = json['snippet']['title'];
    } else {
      origTitle = json['title'];
    }

    String origSlug;
    if (json.containsKey('id')) {
      if (json['id']['videoId'] != null) {
        origSlug = json['id']['videoId'];
      } else {
        origSlug = json['slug'];
      }
    } else {
      origSlug = json['slug'];
    }

    String origPublishedDate;
    if (json.containsKey('publishedDate')) {
      origPublishedDate = json['publishedDate'] ?? '';
    } else {
      origPublishedDate = json['publishTime'] ?? '';
    }

    String photoUrl = Environment().config.mirrorMediaNotImageUrl;
    if (json['heroImage'] != null && json['heroImage'] is String) {
      photoUrl = json['heroImage'];
    } else if (json['heroImage'] != null &&
        json['heroImage']['image'] != null) {
      photoUrl = json['heroImage']['image']['resizedTargets']['mobile']['url'];
    } else if (json['snippet'] != null &&
        json['snippet']['thumbnails'] != null) {
      photoUrl = json['snippet']['thumbnails']['medium']['url'];
    } else if (json['photoUrl'] != null) {
      photoUrl = json['photoUrl'];
    } else if (json['heroImage'] != null) {
      photoUrl = json['heroImage']['resized']['original'];
    }

    if (photoUrl == '') {
      photoUrl = Environment().config.mirrorMediaNotImageUrl;
    }

    List<Category> categoryBuilder = [];

    categoryBuilder = json["categories"] == null || json["categories"] == ""
        ? []
        : Category.categoryListFromJson(json["categories"]);

    String? url;
    if (json.containsKey('style')) {
      if (json['style'] == 'projects') {
        url = '${Environment().config.mirrorMediaDomain}/projects/$origSlug';
      } else if (json['style'] == 'campaign') {
        url = '${Environment().config.mirrorMediaDomain}/campaigns/$origSlug';
      }
    }

    return Record(
      title: origTitle,
      slug: origSlug,
      publishedDate: origPublishedDate,
      photoUrl: photoUrl,
      isExternal: json["partner"] != null && json["partner"] != "",
      isMemberCheck: Category.isMemberOnlyInCategoryList(categoryBuilder),
      url: url,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'slug': slug,
        'publishedDate': publishedDate,
        'photoUrl': photoUrl,
      };

  static List<Record> recordListFromJson(List<dynamic> jsonList) {
    return jsonList.map<Record>((json) => Record.fromJsonK6(json)).toList();
  }

  static List<Record> recordListFromSearchJson(List<dynamic> jsonList) {
    return jsonList
        .map<Record>((json) => Record(
              title: json['title'],
              slug: json['pagemap']['metatags'][0]['dable:item_id'],
              publishedDate: json['pagemap']['metatags'][0]
                  ['article:published_time'],
              photoUrl: json['pagemap']['metatags'][0]['og:image'],
              isExternal: json['link'].contains('external'),
            ))
        .toList();
  }

  static List<Record> filterDuplicatedSlugByAnother(
    List<Record> base,
    List<Record> another,
  ) {
    List<Record> records = [];
    for (var element in base) {
      if (!another.any((record) => record.slug == element.slug)) {
        records.add(element);
      }
    }
    return records;
  }

  @override
  List<Object?> get props =>
      [title, slug, publishedDate, photoUrl, isMemberCheck];
}
