import 'package:readr_app/models/story.dart';

class StoryRes {
  final bool isMember;
  final Story story;

  StoryRes({
    required this.isMember,
    required this.story,
  });

  factory StoryRes.fromJsonK6(Map<String, dynamic> json) {
    return StoryRes(
      isMember: json['isMember'],
      story: Story.fromJsonK6(json),
    );
  }
  /// K3 fromJson 已棄用
  // factory StoryRes.fromJson(Map<String, dynamic> json) {
  //   return StoryRes(
  //     isMember: json['tokenState'] == 'OK',
  //     story: Story.fromJson(json["data"]["_items"][0]),
  //   );
  // }
}