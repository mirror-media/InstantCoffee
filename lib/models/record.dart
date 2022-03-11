import 'package:equatable/equatable.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/category.dart';

class Record extends Equatable {
  final String title;
  final String slug;
  final String publishedDate;
  final String photoUrl;
  final bool isMemberCheck;

  Record({
    required this.title,
    required this.slug,
    required this.publishedDate,
    required this.photoUrl,
    this.isMemberCheck = true,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    // check the search json format
    if(json.containsKey('_source')) {
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
    if (json['heroImage'] != null && json['heroImage']['image'] != null) {
      photoUrl = json['heroImage']['image']['resizedTargets']['mobile']['url'];
    } else if (json['snippet'] != null && json['snippet']['thumbnails'] != null) {
      photoUrl = json['snippet']['thumbnails']['medium']['url'];
    } else if (json['photoUrl'] != null) {
      photoUrl = json['photoUrl'];
    }
    
    List<Category> categoryBuilder = json["categories"] == null
    ? []
    : Category.categoryListFromJson(json["categories"]);

    return Record(
      title: origTitle,
      slug: origSlug,
      publishedDate: origPublishedDate,
      photoUrl: photoUrl,
      isMemberCheck: Category.isMemberOnlyInCategoryList(categoryBuilder),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'slug': slug,
        'publishedDate': publishedDate,
        'photoUrl': photoUrl,
      };

  static List<Record> recordListFromJson(List<dynamic> jsonList) {
    return jsonList.map<Record>((json) => Record.fromJson(json)).toList();
  }

  static List<Record> filterDuplicatedSlugByAnother(
    List<Record> base,
    List<Record> another,
  ) {
    List<Record> records = [];
    base.forEach((element) { 
      if(!another.any((record) => record.slug == element.slug)) {
        records.add(element);
      }
    });
    return records;
  }

  @override
  List<Object?> get props => [
    title, 
    slug, 
    publishedDate, 
    photoUrl, 
    isMemberCheck
  ];
}
