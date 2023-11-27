import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/podcast_info/enclosures.dart';


part 'podcast_info.g.dart';
@JsonSerializable()
class PodcastInfo {
  String? published;
  String? author;
  String? description;
  String? heroImage;
  List<Enclosures>? enclosures;
  String? link;
  String? guid;
  String? title;
  String? duration;

  PodcastInfo({this.published,
    this.author,
    this.description,
    this.heroImage,
    this.enclosures,
    this.link,
    this.guid,
    this.title,
    this.duration});

  factory PodcastInfo.fromJson(Map<String, dynamic> json) => _$PodcastInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastInfoToJson(this);

}