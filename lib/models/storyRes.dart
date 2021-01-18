import 'package:readr_app/models/story.dart';

class StoryRes {
  final bool isMember;
  final Story story;

  StoryRes({
    this.isMember,
    this.story,
  });

  factory StoryRes.fromJson(Map<String, dynamic> json) {
    print(json);
    return StoryRes(
      isMember: json['tokenState'] == 'OK',
      story: Story.fromJson(json["data"]["_items"][0]),
    );
  }
}