import 'package:readr_app/helpers/environment.dart';

class ExternalStory {
  String? title;
  String? subtitle;
  String? slug;
  String? publishedDate;
  String? extendByLine;
  String? heroImage;
  String? content;

  ExternalStory({
    this.title,
    this.subtitle,
    this.slug,
    this.publishedDate,
    this.extendByLine,
    this.heroImage,
    this.content,
  });

  factory ExternalStory.fromJsonK6(Map<String, dynamic> json) {
    String photoUrl = Environment().config.mirrorMediaNotImageUrl;
    if (json.containsKey('thumb')) {
      photoUrl = json['thumb'];
    }

    return ExternalStory(
      title: json['title'],
      slug: json['slug'],
      publishedDate: json['publishedDate'],
      extendByLine: json['extend_byline'],
      heroImage: photoUrl,
      content: json['content'],
    );
  }

  factory ExternalStory.fromJson(Map<String, dynamic> json) {
    String photoUrl = Environment().config.mirrorMediaNotImageUrl;
    if (json.containsKey('thumb')) {
      photoUrl = json['thumb'];
    }

    return ExternalStory(
      title: json['title'],
      subtitle: json['subtitle'],
      slug: json['name'],
      publishedDate: json['publishedDate'],
      extendByLine: json['extend_byline'],
      heroImage: photoUrl,
      content: json['content'],
    );
  }
}
