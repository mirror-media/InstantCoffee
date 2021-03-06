import 'package:readr_app/env.dart';

class Record {
  String title;
  String slug;
  String publishedDate;
  String photoUrl;

  Record({
    this.title,
    this.slug,
    this.publishedDate,
    this.photoUrl,
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
      origPublishedDate = json['publishTime'];
    }

    String photoUrl = env.baseConfig.mirrorMediaNotImageUrl;
    if (json.containsKey('heroImage') && json['heroImage'] != null && json['heroImage']['image'] != null) {
      photoUrl = json['heroImage']['image']['resizedTargets']['mobile']['url'];
    } else if (json.containsKey('snippet') && json['snippet'] != null) {
      photoUrl = json['snippet']['thumbnails']['medium']['url'];
    } else if (json.containsKey('photoUrl') && json['photoUrl'] != null) {
      photoUrl = json['photoUrl'];
    }

    return Record(
      title: origTitle,
      slug: origSlug,
      publishedDate: origPublishedDate,
      photoUrl: photoUrl,
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
}
