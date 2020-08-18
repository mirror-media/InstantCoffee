import 'package:readr_app/helpers/constants.dart';

class Record {
  String title;
  String slug;
  String publishedDate;
  String photo;

  Record({
    this.title,
    this.slug,
    this.publishedDate,
    this.photo,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    String photoUrl = mirrorMediaNotImageUrl;
    if (json.containsKey('heroImage') && json['heroImage'] != null) {
      photoUrl = json['heroImage']['image']['resizedTargets']['mobile']['url'];
    }
    return Record(
      title: json['title'],
      slug: json['slug'],
      publishedDate: json['publishedDate'],
      photo: photoUrl,
    );
  }

  factory Record.fromListingJson(Map<String, dynamic> json) {
    String photoUrl = mirrorMediaNotImageUrl;
    if (json.containsKey('snippet') && json['snippet']['thumbnails'] != null) {
      photoUrl = json['snippet']['thumbnails']['medium']['url'];
    }
    return Record(
      title: json['snippet']['title'],
      slug: json['id']['videoId'],
      publishedDate: json['publishTime'],
      photo: photoUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'slug': slug,
        'publishedDate': publishedDate,
        'heroImage': {
          'image': {
            'resizedTargets': {
              'mobile': {'url': photo}
            }
          }
        },
      };
}
