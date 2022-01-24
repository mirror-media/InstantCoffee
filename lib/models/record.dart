import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/category.dart';

class Record {
  String title;
  String slug;
  String publishedDate;
  String photoUrl;
  bool isMemberCheck;
  bool isMemberContent;

  Record({
    required this.title,
    required this.slug,
    required this.publishedDate,
    required this.photoUrl,
    this.isMemberCheck = true,
    this.isMemberContent = false,
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
      origPublishedDate = json['publishedDate'];
    } else {
      origPublishedDate = json['publishTime'] ?? '';
    }

    String photoUrl = Environment().config.mirrorMediaNotImageUrl;
    if (json.containsKey('heroImage') && json['heroImage'] != null && json['heroImage']['image'] != null) {
      photoUrl = json['heroImage']['image']['resizedTargets']['mobile']['url'];
    } else if (json.containsKey('snippet') && json['snippet'] != null) {
      photoUrl = json['snippet']['thumbnails']['medium']['url'];
    } else if (json.containsKey('photoUrl') && json['photoUrl'] != null) {
      photoUrl = json['photoUrl'];
    }
    
    List<Category> categoryBuilder = [];
    if (json["categories"] != null) {
      for (int i = 0; i < json["categories"].length; i++) {
        Category category = Category.fromJson(json["categories"][i]);
        categoryBuilder.add(category);
      }
    }

    bool isMemberContent = false;
    if(json["sections"] != null){
      for (int i = 0; i < json["sections"].length; i++){
        if(json["sections"][i]["name"] == 'member'){
          isMemberContent = true;
        }
      }
    }

    return Record(
      title: origTitle,
      slug: origSlug,
      publishedDate: origPublishedDate,
      photoUrl: photoUrl,
      isMemberCheck: categoryBuilder.length == 0
      ? true
      : Category.isMemberOnlyInCategoryList(categoryBuilder),
      isMemberContent: isMemberContent,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'slug': slug,
        'publishedDate': publishedDate,
        'photoUrl': photoUrl,
      };

  @override
  int get hashCode => this.hashCode;

  @override
  bool operator ==(covariant Record other) {
    // compare this to other
    return this.slug == other.slug;
  }

  static List<Record> recordListFromJson(List<dynamic> jsonList) {
    return jsonList.map<Record>((json) => Record.fromJson(json)).toList();
  }

  static List<Record> filterDuplicatedSlugByAnother(
    List<Record> base,
    List<Record> another,
  ) {
    List<Record> records = [];
    base.forEach((element) { 
      if(!another.contains(element)) {
        records.add(element);
      }
    });
    return records;
  }
}
