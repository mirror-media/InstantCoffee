import 'package:readr_app/models/storyAd.dart';

class Listening {
  String slug;
  String title;
  String description;
  String photoUrl;
  String publishedAt;

  StoryAd? storyAd;
  
  Listening({
    required this.slug,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.publishedAt,

    this.storyAd,
  });

  factory Listening.fromJson(Map<String, dynamic> json) {
    return Listening(
      slug: json['id'],
      title: json['snippet']['title'],
      description: json['snippet']['description'],
      photoUrl: json['snippet']['thumbnails']['medium']['url'],
      publishedAt: json['snippet']['publishedAt'],
    );
  }
}
